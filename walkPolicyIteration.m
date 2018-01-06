function policy = walkPolicyIteration(states, actions, state_transition, rew, gamma, iterations)
%   walkPolicyIteration generates a control policy for a bipedal gait using the
%   Policy Iteration Algorithm

%% Policy iteration
 % inits
 policy = ceil(rand(16,1)*4);
 V_old = zeros(16,1);
 V_new = V_old;
 
 % learning phase
 for i = 1 : iterations
     
     % Evaluate policy
     for s = 1 : size(states,2)
         
         a = policy(s); % action
         V_new(s) = rew(s,a) + ...
             gamma * V_old(state_transition(s,a));
         
     end
     
     % Generate new policy
     for s = 1 : size(states,2)
         
         % Get best action for state s
         best_action = 1;
         best_val = rew(s,1) + ...
             gamma * V_new(state_transition(s,1));
         for a = 2 : size(actions,2)
             
             val = rew(s,a) + ...
                 gamma * V_new(state_transition(s,a));
             if (best_val < val)
                 best_val = val;
                 best_action = a;
             end
         end
         
         % Update policy
         policy(s) = best_action; 
     end
     
     % Prepare for the next iteration
     V_old = V_new;
 end
end

