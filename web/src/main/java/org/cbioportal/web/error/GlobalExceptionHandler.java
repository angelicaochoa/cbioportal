package org.cbioportal.web.error;

import org.cbioportal.service.exception.PatientNotFoundException;
import org.cbioportal.service.exception.SampleNotFoundException;
import org.cbioportal.service.exception.StudyNotFoundException;
import org.cbioportal.web.exception.*;
import org.cbioportal.web.parameter.PagingConstants;
import org.springframework.beans.TypeMismatchException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice("org.cbioportal.web")
public class GlobalExceptionHandler {

    @ExceptionHandler(UnsupportedOperationException.class)
    public ResponseEntity<ErrorResponse> handleUnsupportedOperation() {

        return new ResponseEntity<>(new ErrorResponse("Requested API is not implemented yet"),
                HttpStatus.NOT_IMPLEMENTED);
    }

    @ExceptionHandler(StudyNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleStudyNotFound(StudyNotFoundException ex) {

        return new ResponseEntity<>(new ErrorResponse("Study not found: " + ex.getStudyId()),
                HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(PatientNotFoundException.class)
    public ResponseEntity<ErrorResponse> handlePatientNotFound(PatientNotFoundException ex) {

        return new ResponseEntity<>(new ErrorResponse("Patient not found: " + ex.getPatientId()),
                HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(SampleNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleSampleNotFound(SampleNotFoundException ex) {

        return new ResponseEntity<>(new ErrorResponse("Sample not found: " + ex.getSampleId()),
                HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<ErrorResponse> handleMissingServletRequestParameter(MissingServletRequestParameterException ex) {

        return new ResponseEntity<>(new ErrorResponse("Request parameter is missing: " + ex.getParameterName()),
                HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(TypeMismatchException.class)
    public ResponseEntity<ErrorResponse> handleTypeMismatch(TypeMismatchException ex) {

        return new ResponseEntity<>(new ErrorResponse("Request parameter type mismatch: " + ex.getMessage()),
                HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(PageSizeTooBigException.class)
    public ResponseEntity<ErrorResponse> handlePageSizeTooBig(PageSizeTooBigException ex) {

        return new ResponseEntity<>(new ErrorResponse("Page size " + ex.getPageSize()
                + " is greater than the maximum allowed: " + PagingConstants.MAX_PAGE_SIZE), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(PageSizeTooSmallException.class)
    public ResponseEntity<ErrorResponse> handlePageSizeTooSmall(PageSizeTooSmallException ex) {

        return new ResponseEntity<>(new ErrorResponse("Page size " + ex.getPageSize()
                + " is smaller than the minimum allowed: " + PagingConstants.MIN_PAGE_SIZE), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(PageSizeInvalidFormatException.class)
    public ResponseEntity<ErrorResponse> handlePageSizeInvalidFormat(PageSizeInvalidFormatException ex) {

        return new ResponseEntity<>(new ErrorResponse("Page size " + ex.getPageSize() + " must be integer"),
                HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(PageNumberTooSmallException.class)
    public ResponseEntity<ErrorResponse> handlePageNumberTooSmall(PageNumberTooSmallException ex) {

        return new ResponseEntity<>(new ErrorResponse("Page number " + ex.getPageNumber()
                + " is smaller than the minimum allowed: " + PagingConstants.MIN_PAGE_NUMBER), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(PageNumberInvalidFormatException.class)
    public ResponseEntity<ErrorResponse> handlePageNumberInvalidFormat(PageNumberInvalidFormatException ex) {

        return new ResponseEntity<>(new ErrorResponse("Page number " + ex.getPageNumber() + " must be integer"),
                HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponse> handleHttpMessageNotReadable(HttpMessageNotReadableException ex) {

        return new ResponseEntity<>(new ErrorResponse("There is an error in the JSON format of the request payload"),
                HttpStatus.BAD_REQUEST);
    }
}
