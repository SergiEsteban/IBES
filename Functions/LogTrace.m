function LogTrace(handles, ts, trace)
txt         = cellstr(get(handles.Logger,'String'));
txt{end+1,1}  = [ts, ' ', trace];
set(handles.Logger,'String', txt);
end