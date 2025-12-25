function sliceProgressUpdate(job, k, numSlices, name)
    
    pctJob   = 100 * job.count / job.total;
    pctSlice = 100 * k / numSlices;
    
    fprintf(['Slicer measurements progress: ' ...
                'Subject %d/%d | Level %s | %.1f%% slices | %.1f%% total\n'], ...
                job.subjectIdx, job.numSubjects, name, pctSlice, pctJob);
end

