package metastore.controllers;

import metastore.services.JobService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * API to manage jobs.
 *
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Controller
public class JobController {

    @Autowired
    JobService jobService;

    @RequestMapping(value = "/api/jobs/{jobId}/delete-events", method = RequestMethod.PUT)
    public @ResponseBody String deleteJobEvents(@PathVariable("jobId") Long jobId) {
        int numberEventsDeleted = jobService.deleteJobEvents(jobId);
        return "Deleted " + numberEventsDeleted + " events";
    }
}
