function newStruct = saveToStruct(obj)              
%     varname = inputname(1);              
    props = properties(obj);              
        for p = 1:numel(props)                  
            s.(props{p})=obj.(props{p});             
        end
%         eval([varname ' = s']);   
        newStruct = s;
%         save(filename, varname)          
end

