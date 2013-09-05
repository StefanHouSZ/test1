path = " F:\\TEST1\\TEST2\\TEST3"
def mkdirs(path)
    if(!File.directory?(path))
        if(!mkdirs(File.dirname(path)))
            return false;
        end
        Dir.mkdir(path)
    end
#    return true
end

mkdirs(path)