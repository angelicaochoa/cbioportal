package org.cbioportal.web;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.cbioportal.web.exception.PageSizeTooBigException;
import org.cbioportal.web.parameter.ClinicalDataIdentifier;
import org.cbioportal.model.summary.ClinicalDataSummary;
import org.cbioportal.service.ClinicalDataService;
import org.cbioportal.web.parameter.ClinicalDataType;
import org.cbioportal.web.parameter.Direction;
import org.cbioportal.web.parameter.HeaderKeyConstants;
import org.cbioportal.web.parameter.PagingConstants;
import org.cbioportal.web.parameter.Projection;
import org.cbioportal.web.parameter.sort.ClinicalDataSortBy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@Api(tags = "Clinical Data", description = " ")
public class ClinicalDataController {

    @Autowired
    private ClinicalDataService clinicalDataService;

    @RequestMapping(value = "/studies/{studyId}/samples/{sampleId}/clinical-data", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation("Get all clinical data of a sample in a study")
    public ResponseEntity<List<? extends ClinicalDataSummary>> getAllClinicalDataOfSampleInStudy(
            @ApiParam(required = true, value = "Study ID")
            @PathVariable String studyId,
            @ApiParam(required = true, value = "Sample ID")
            @PathVariable String sampleId,
            @ApiParam("Attribute ID")
            @RequestParam(required = false) String attributeId,
            @ApiParam("Level of detail of the response")
            @RequestParam(defaultValue = "SUMMARY") Projection projection,
            @ApiParam("Page size of the result list")
            @RequestParam(defaultValue = PagingConstants.DEFAULT_PAGE_SIZE) Integer pageSize,
            @ApiParam("Page number of the result list")
            @RequestParam(defaultValue = PagingConstants.DEFAULT_PAGE_NUMBER) Integer pageNumber,
            @ApiParam("Name of the property that the result list is sorted by")
            @RequestParam(required = false) ClinicalDataSortBy sortBy,
            @ApiParam("Direction of the sort")
            @RequestParam(defaultValue = "ASC") Direction direction) {

        if (projection == Projection.META) {
            HttpHeaders responseHeaders = new HttpHeaders();
            responseHeaders.add(HeaderKeyConstants.TOTAL_COUNT, clinicalDataService.getMetaSampleClinicalData(
                    studyId, sampleId, attributeId).getTotalCount().toString());
            return new ResponseEntity<>(responseHeaders, HttpStatus.OK);
        } else {
            return new ResponseEntity<List<? extends ClinicalDataSummary>>(
                    clinicalDataService.getAllClinicalDataOfSampleInStudy(
                            studyId, sampleId, attributeId, projection.name(), pageSize, pageNumber,
                            sortBy == null ? null : sortBy.name(), direction.name()), HttpStatus.OK);
        }
    }

    @RequestMapping(value = "/studies/{studyId}/patients/{patientId}/clinical-data", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation("Get all clinical data of a patient in a study")
    public ResponseEntity<List<? extends ClinicalDataSummary>> getAllClinicalDataOfPatientInStudy(
            @ApiParam(required = true, value = "Study ID")
            @PathVariable String studyId,
            @ApiParam(required = true, value = "Patient ID")
            @PathVariable String patientId,
            @ApiParam("Attribute ID")
            @RequestParam(required = false) String attributeId,
            @ApiParam("Level of detail of the response")
            @RequestParam(defaultValue = "SUMMARY") Projection projection,
            @ApiParam("Page size of the result list")
            @RequestParam(defaultValue = PagingConstants.DEFAULT_PAGE_SIZE) Integer pageSize,
            @ApiParam("Page number of the result list")
            @RequestParam(defaultValue = PagingConstants.DEFAULT_PAGE_NUMBER) Integer pageNumber,
            @ApiParam("Name of the property that the result list is sorted by")
            @RequestParam(required = false) ClinicalDataSortBy sortBy,
            @ApiParam("Direction of the sort")
            @RequestParam(defaultValue = "ASC") Direction direction) {

        if (projection == Projection.META) {
            HttpHeaders responseHeaders = new HttpHeaders();
            responseHeaders.add(HeaderKeyConstants.TOTAL_COUNT, clinicalDataService.getMetaPatientClinicalData(
                    studyId, patientId, attributeId).getTotalCount().toString());
            return new ResponseEntity<>(responseHeaders, HttpStatus.OK);
        } else {
            return new ResponseEntity<List<? extends ClinicalDataSummary>>(
                    clinicalDataService.getAllClinicalDataOfPatientInStudy(
                            studyId, patientId, attributeId, projection.name(), pageSize, pageNumber,
                            sortBy == null ? null : sortBy.name(), direction.name()), HttpStatus.OK);
        }
    }

    @RequestMapping(value = "/studies/{studyId}/clinical-data", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation("Get all clinical data in a study")
    public ResponseEntity<List<? extends ClinicalDataSummary>> getAllClinicalDataInStudy(
            @ApiParam(required = true, value = "Study ID")
            @PathVariable String studyId,
            @ApiParam("Attribute ID")
            @RequestParam(required = false) String attributeId,
            @ApiParam("Type of the clinical data")
            @RequestParam(defaultValue = "SAMPLE") ClinicalDataType clinicalDataType,
            @ApiParam("Level of detail of the response")
            @RequestParam(defaultValue = "SUMMARY") Projection projection,
            @ApiParam("Page size of the result list")
            @RequestParam(defaultValue = PagingConstants.DEFAULT_PAGE_SIZE) Integer pageSize,
            @ApiParam("Page number of the result list")
            @RequestParam(defaultValue = PagingConstants.DEFAULT_PAGE_NUMBER) Integer pageNumber,
            @ApiParam("Name of the property that the result list is sorted by")
            @RequestParam(required = false) ClinicalDataSortBy sortBy,
            @ApiParam("Direction of the sort")
            @RequestParam(defaultValue = "ASC") Direction direction) {

        if (projection == Projection.META) {
            HttpHeaders responseHeaders = new HttpHeaders();
            responseHeaders.add(HeaderKeyConstants.TOTAL_COUNT, clinicalDataService.getMetaAllClinicalData(studyId,
                    attributeId, clinicalDataType == null ? null : clinicalDataType.name()).getTotalCount().toString());
            return new ResponseEntity<>(responseHeaders, HttpStatus.OK);
        } else {
            return new ResponseEntity<List<? extends ClinicalDataSummary>>(
                    clinicalDataService.getAllClinicalDataInStudy(studyId, attributeId,
                            clinicalDataType == null ? null : clinicalDataType.name(), projection.name(), pageSize,
                            pageNumber, sortBy == null ? null : sortBy.name(), direction.name()), HttpStatus.OK);
        }
    }

    @RequestMapping(value = "/clinical-data/fetch", method = RequestMethod.POST,
            consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation("Fetch clinical data by patient IDs or sample IDs")
    public ResponseEntity<List<? extends ClinicalDataSummary>> fetchClinicalData(
            @ApiParam("Attribute ID")
            @RequestParam(required = false) String attributeId,
            @ApiParam("Type of the clinical data")
            @RequestParam(defaultValue = "SAMPLE") ClinicalDataType clinicalDataType,
            @ApiParam("Level of detail of the response")
            @RequestParam(defaultValue = "SUMMARY") Projection projection,
            @ApiParam(required = true, value = "List of patient or sample identifiers")
            @RequestBody List<ClinicalDataIdentifier> identifiers) throws PageSizeTooBigException {

        if (identifiers.size() > PagingConstants.MAX_PAGE_SIZE) {
            throw new PageSizeTooBigException(identifiers.size());
        }

        List<String> studyIds = new ArrayList<>();
        List<String> ids = new ArrayList<>();

        for (ClinicalDataIdentifier identifier : identifiers) {
            studyIds.add(identifier.getStudyId());
            ids.add(identifier.getId());
        }

        if (projection == Projection.META) {
            HttpHeaders responseHeaders = new HttpHeaders();
            responseHeaders.add(HeaderKeyConstants.TOTAL_COUNT, clinicalDataService.fetchMetaClinicalData(studyIds, ids,
                    attributeId, clinicalDataType == null ? null : clinicalDataType.name()).getTotalCount().toString());
            return new ResponseEntity<>(responseHeaders, HttpStatus.OK);
        } else {
            return new ResponseEntity<List<? extends ClinicalDataSummary>>(
                    clinicalDataService.fetchClinicalData(studyIds, ids, attributeId,
                            clinicalDataType == null ? null : clinicalDataType.name(), projection.name()),
                    HttpStatus.OK);
        }
    }
}
