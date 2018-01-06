% Applied Biorobotics
% Technical University of Munich, WS17
% Reinforcement Learning for Bipedal Gait Generation
% Daniel Gheorghita
close all;
clear all;
clc;

% Actions:
% 1 - move right leg up/down
% 2 - move right leg back/forward
% 3 - move left leg up/down
% 4 - move left leg back/forward
actions = [1:4];

% States
states = [1:16];

% State transition matrix
state_transition = ...
    [2  4   5   13; ...
     1  3   6   14; ...
     4  2   7   15; ...
     3  1   8   16; ...
     6  8   1   9; ...
     5  7   2   10; ...
     8  6   3   11; ...
     7  5   4   12; ...
     10 12  13  5; ...
     9  11  14  6; ...
     12 10  15  7; ...
     11 9   16  8; ...
     14 16  9   1; ...
     13 15  10  2; ...
     16 14  11  3; ...
     15 13  12  4];
 
 %% Reward matrix
 rew_value = 10;
 rew = zeros(16,4);
 
 %% Positive reward for forward motion
 % Move the front leg backwards while the other one is up
 rew(8,2) = rew_value;
 rew(14,4) = rew_value;
 
 %% Negative value for failing to move forward
 
 % lift left leg when right leg is up
 rew(3,3) = -rew_value;
 rew(2,3) = -rew_value;
 rew(14,3) = -rew_value;
 rew(15,3) = -rew_value;
 
 % lift right leg when left leg is up
 rew(9,1) = -rew_value;
 rew(12,1) = -rew_value;
 rew(8,1) = -rew_value;
 rew(5,1) = -rew_value;
 
 % move backwards due to right leg
 rew(1,2) = -rew_value;
 rew(5,2) = -rew_value;
 rew(9,2) = -rew_value;
 rew(13,2) = -rew_value;
 
 % move backwards due to left leg
 rew(1,4) = -rew_value;
 rew(2,4) = -rew_value;
 rew(3,4) = -rew_value;
 rew(4,4) = -rew_value;
 
%% Call policy iteration learning
gamma = 0.9;
iterations = 20;
%policy = walkPolicyIteration(states, actions, state_transition, rew, gamma, iterations);

%% Call Q learning
alpha = 0.8;
epsilon = 0.2;
gamma = 0.9;
iterations = 1000000;
policy = walkQLearning(states, actions, state_transition, rew, alpha, gamma, epsilon, iterations);

 %% Generate gait based on policy
state_seq = zeros(16,1);
state_seq(1) = 8; % initial state
for s = 2 : size(states,2)
    state_seq(s) = state_transition(state_seq(s-1),policy(state_seq(s-1)));
end

%% Display gait
walkshow(state_seq');