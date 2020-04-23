function [ fullarray ] = generatemissingdata( array, NumEQ, ResponseType )
% This function is used for generating missing data, which is caused by
% collapsed cases in IDA. 

% Count the number of nonzero elements in array
 n = nnz(array(:,4:end));
 fullarray = zeros(length(array),size(array,2));
 fullarray(:,1:3) = array(:,1:3);
 q = nnz(array(:,5:end));
if n == 0 & ResponseType == 'SDR'
    fullarray(:,4:end) = ones(size(array(:,4:end),1),size(array(:,4:end),2))*(0.2);
    
    else if n == 0 & ResponseType == 'RDR'
        fullarray(:,4:end) = ones(size(array(:,4:end),1),size(array(:,4:end),2))*(0.01);
        
        else if q == 0 & ResponseType == 'PFA'
            fullarray(:,4) = array(:,4);
            for i = 5:size(array,2)
                fullarray(:,i) = array(:,4);
            end
            
            
                else if ResponseType == 'PFA' 

                    fullarray(:,4) = array(:,4);

                    for i = 5:size(array,2)

                        mu = mean(nonzeros(array(:,i)));
                        sigma = std(nonzeros(array(:,i)));
                        beta = sqrt(log((sigma/mu)^2 + 1));
                        theta = log(mu)-0.5*beta^2;

                        for j = 1:NumEQ
                            if array(j,i) == 0
                                fullarray(j,i) = lognrnd(theta,beta);
                            else fullarray(j,i) = array(j,i);
                            end
                        end
                    end

                     else 

                        for i = 4:size(array,2)

                             mu = mean(nonzeros(array(:,i)));
                             sigma = std(nonzeros(array(:,i)));
                             beta = sqrt(log((sigma/mu)^2 + 1));
                             theta = log(mu)-0.5*beta^2;
                             dist = makedist('Lognormal','mu',theta,'sigma',beta);
                             truncatedist = truncate(dist,0,0.2);

                             for j = 1:NumEQ
                                 if array(j,i) == 0
                                    fullarray(j,i) = random(truncatedist);
                                 else fullarray(j,i) = array(j,i);
                                 end
                             end

                        end
                    end
                
             end
         end
end

if ResponseType == 'SDR'
    for i = 4:size(array,2)
        n = nnz(array(:,i));
        if n == 1
            fullarray(:,i) = ones(size(array(:,i),1),size(array(:,i),2))*(sum(array(:,i)));
        else fullarray(:,i) = fullarray(:,i);
        end
    end
    
    else if ResponseType == 'PFA' 
            for i = 5:size(array,2)
            n = nnz(array(:,i));
                if n == 1
                    fullarray(:,i) = ones(size(array(:,i),1),size(array(:,i),2))*(sum(array(:,i)));
                else fullarray(:,i) = fullarray(:,i);

                end
            end
        
    else 
        n = nnz(array(:,4));
        if n == 1;
            fullarray(:,4) = ones(size(array(:,4),1),size(array(:,4),2))*(sum(array(:,4)));
        else fullarray(:,4) = fullarray(:,4);

    end
end
 end
 
