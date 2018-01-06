function policy = walkQLearning(states, actions, state_transition, rew, alpha, gamma, epsilon, iterations)
%   walkQLearning generates a control policy for a bipedal gait using the
%   Q Learning Algorithm

%% Policy iteration
 % inits
 policy = ceil(rand(16,1)*4);
 Q = zeros(16,4);
 % learning parameters
 %iterations = 2;
 %gamma = 0.9;
 
 s = 1; % start from state 1 (it does not matter here)
 
 % learning phase
 for i = 1 : iterations
         
    % Get (epsilon-greedy) action for state s
    randomNumber = rand(1);
    if (randomNumber > epsilon)
        % Exploitation
        [~,best_action] = max(Q(s,:),[],2);
    else
        % Exploration
        best_action = ceil(rand(1)*4);
    end
         
    % Get best action for state s_next
    s_next = state_transition(s,best_action);
    [~,best_next_action] = max(Q(s_next,:),[],2);

    % Update Q matrix
    Q(s,best_action) = Q(s,best_action) + alpha * (rew(s,best_action) + ...
        gamma * (Q(s_next,best_next_action) - Q(s,best_action)));
     
     % Update policy
     policy(s) = best_action;
     
     % Move to the next state
     s = s_next;
 end
end