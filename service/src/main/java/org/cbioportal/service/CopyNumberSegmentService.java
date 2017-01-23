package org.cbioportal.service;

import org.cbioportal.model.CopyNumberSeg;
import org.cbioportal.model.meta.BaseMeta;

import java.util.List;

public interface CopyNumberSegmentService {

    List<CopyNumberSeg> getCopyNumberSegmentsInSampleInStudy(String studyId, String sampleId, String projection,
                                                             Integer pageSize, Integer pageNumber, String sortBy,
                                                             String direction);

    BaseMeta getMetaCopyNumberSegmentsInSampleInStudy(String studyId, String sampleId);

    List<CopyNumberSeg> fetchCopyNumberSegments(List<String> studyIds, List<String> sampleIds, String projection);

    BaseMeta fetchMetaCopyNumberSegments(List<String> studyIds, List<String> sampleIds);
}
