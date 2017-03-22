package org.cbioportal.service.impl;

import org.cbioportal.model.Sample;
import org.cbioportal.model.meta.BaseMeta;
import org.cbioportal.persistence.SampleRepository;
import org.cbioportal.service.SampleService;
import org.cbioportal.service.exception.SampleNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SampleServiceImpl implements SampleService {

    @Autowired
    private SampleRepository sampleRepository;

    @Override
    @PreAuthorize("hasPermission(#studyId, 'CancerStudy', 'read')")
    public List<Sample> getAllSamplesInStudy(String studyId, String projection, Integer pageSize, Integer pageNumber,
                                             String sortBy, String direction) {

        return sampleRepository.getAllSamplesInStudy(studyId, projection, pageSize, pageNumber, sortBy, direction);
    }

    @Override
    @PreAuthorize("hasPermission(#studyId, 'CancerStudy', 'read')")
    public BaseMeta getMetaSamplesInStudy(String studyId) {

        return sampleRepository.getMetaSamplesInStudy(studyId);
    }

    @Override
    @PreAuthorize("hasPermission(#studyId, 'CancerStudy', 'read')")
    public Sample getSampleInStudy(String studyId, String sampleId) throws SampleNotFoundException {

        Sample sample = sampleRepository.getSampleInStudy(studyId, sampleId);

        if (sample == null) {
            throw new SampleNotFoundException(studyId, sampleId);
        }

        return sample;
    }

    @Override
    @PreAuthorize("hasPermission(#studyId, 'CancerStudy', 'read')")
    public List<Sample> getAllSamplesOfPatientInStudy(String studyId, String patientId, String projection,
                                                      Integer pageSize, Integer pageNumber, String sortBy,
                                                      String direction) {

        return sampleRepository.getAllSamplesOfPatientInStudy(studyId, patientId, projection, pageSize, pageNumber,
                sortBy, direction);
    }

    @Override
    @PreAuthorize("hasPermission(#studyId, 'CancerStudy', 'read')")
    public BaseMeta getMetaSamplesOfPatientInStudy(String studyId, String patientId) {

        return sampleRepository.getMetaSamplesOfPatientInStudy(studyId, patientId);
    }

    @Override
    @PreAuthorize("hasPermission(#studyIds, 'List<CancerStudyId>', 'read')")
    public List<Sample> fetchSamples(List<String> studyIds, List<String> sampleIds, String projection) {

        return sampleRepository.fetchSamples(studyIds, sampleIds, projection);
    }

    @Override
    @PreAuthorize("hasPermission(#studyIds, 'List<CancerStudyId>', 'read')")
    public BaseMeta fetchMetaSamples(List<String> studyIds, List<String> sampleIds) {

        return sampleRepository.fetchMetaSamples(studyIds, sampleIds);
    }

    // this is not secured as it is only used interally by other services which have
    // already had permissions checked
    @Override
    public List<Sample> getSamplesByInternalIds(List<Integer> internalIds) {

        return sampleRepository.getSamplesByInternalIds(internalIds);
    }
}
