package metastore.controllers;

import metastore.models.Setting;
import metastore.models.Stream;
import metastore.models.XdJob;
import metastore.repositories.SettingRepository;
import metastore.repositories.StreamRepository;
import metastore.repositories.XdJobRepository;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;


/**
 * Created by markmo on 21/05/15.
 */
@Controller
public class StreamController {

    private static final Log log = LogFactory.getLog(StreamController.class);

    static final String SPRING_XD_API_SETTING = "spring-xd-api";

    static final String SCRIPTS_DIR_SETTING = "scripts-dir";

    static final String SFTP_HOST = "sftp-host";

    static final String LOCAL_LANDING_DIR = "local-landing-dir";

    static final String SFTP_USER = "sftp-user";

    static final String SFTP_PASSWORD = "sftp-password";

    @Autowired
    SettingRepository settingRepository;

    @Autowired
    XdJobRepository jobRepository;

    @Autowired
    StreamRepository streamRepository;

    @Autowired
    RestTemplate restTemplate;

    @RequestMapping(value = "/api/xd-jobs/upload", consumes = "multipart/form-data", method = RequestMethod.POST)
    public @ResponseBody String deployXdJob(@RequestParam String name,
                                            @RequestParam boolean makeUnique,
                                            @RequestParam MultipartFile file) throws IOException {
        if (log.isDebugEnabled()) {
            log.debug("deployXdJob called");
        }
        String api = settingRepository.findOne(SPRING_XD_API_SETTING).getValue();
        List<XdJob> jobs = jobRepository.findByNameIgnoreCase(name);
        XdJob job;
        if (jobs == null || jobs.isEmpty()) {
            if (log.isDebugEnabled()) {
                log.debug("Creating new job");
            }
            job = new XdJob();
            job.setName(name);
            job.setMakeUnique(makeUnique);
            job.setJarLocation(file.getOriginalFilename());
            jobRepository.save(job);
        } else {
            job = jobs.get(0);
            String oldName = job.getName();
            if (log.isDebugEnabled()) {
                log.debug("Found existing job " + oldName);
            }
            job.setName(name);
            job.setMakeUnique(makeUnique);
            job.setJarLocation(file.getOriginalFilename());
            jobRepository.save(job);

            if (log.isDebugEnabled()) {
                log.debug("Deleting job definition: " + api + "jobs/definitions/" + oldName + "job");
            }
            try {
                restTemplate.delete(api + "jobs/definitions/" + oldName + "job");
            } catch (RestClientException e) {
                log.warn("Job " + oldName + "job already deleted perhaps; " + e.getMessage(), e);
            }

            if (log.isDebugEnabled()) {
                log.debug("Deleting module: " + api + "modules/job/" + oldName);
            }
            try {
                restTemplate.delete(api + "modules/job/" + oldName);
            } catch (RestClientException e) {
                log.warn("Module " + oldName + " already deleted perhaps; " + e.getMessage(), e);
            }
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        HttpEntity<Object> entity = new HttpEntity<Object>(file.getBytes(), headers);
        if (log.isDebugEnabled()) {
            log.debug("Uploading job");
        }
        try {
            restTemplate.postForObject(api + "modules/job/" + name, entity, Object.class);
        } catch (RestClientException e) {
            log.error(e.getMessage(), e);
            return e.getMessage();
        }
        if (log.isDebugEnabled()) {
            log.debug("Uploaded job done");
        }

        String definition = name + " --makeUnique=" + Boolean.toString(makeUnique);
        MultiValueMap<String, String> values = new LinkedMultiValueMap<String, String>();
        values.add("name", name + "job");
        values.add("definition", definition);
        HttpHeaders jobHeaders = new HttpHeaders();
        jobHeaders.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        HttpEntity<MultiValueMap<String, String>> jobEntity = new HttpEntity<MultiValueMap<String, String>>(values, jobHeaders);
        if (log.isDebugEnabled()) {
            log.debug("Creating job definition " + definition);
        }
        try {
            restTemplate.postForObject(api + "jobs/definitions", jobEntity, Object.class);
        } catch (RestClientException e) {
            log.error(e.getMessage(), e);
            return e.getMessage();
        }
        return "Successfully uploaded Job " + name;
    }

    @RequestMapping(value = "/api/xd-jobs/{jobId}/deploy", method = RequestMethod.PUT)
    public @ResponseBody String deployXdJob(@PathVariable("jobId") Integer jobId) {
        XdJob job = jobRepository.findOne(jobId);
        return deploy(job);
    }

    @RequestMapping(value = "/api/xd/undeploy", method = RequestMethod.PUT)
    public @ResponseBody String undeployEverything() {
        String api = settingRepository.findOne(SPRING_XD_API_SETTING).getValue();
        for (XdJob job : jobRepository.findAll()) {
            String name = job.getName();
            if (log.isDebugEnabled()) {
                log.debug("Deleting job definition: " + api + "jobs/definitions/" + name + "job");
            }
            try {
                restTemplate.delete(api + "jobs/definitions/" + name + "job");
            } catch (RestClientException e) {
                log.warn("Job " + name + " already deleted perhaps; " + e.getMessage(), e);
            }
        }
        for (Stream stream : streamRepository.findAll()) {
            String name = stream.getName();
            try {
                restTemplate.delete(api + "streams/definitions/" + name);
            } catch (RestClientException e) {
                log.warn("Stream " + name + " already deleted perhaps; " + e.getMessage(), e);
            }
        }
        return "Successfully redeployed everything";
    }

    @RequestMapping(value = "/api/xd/reset", method = RequestMethod.DELETE)
    public @ResponseBody String removeEverything() {
        String api = settingRepository.findOne(SPRING_XD_API_SETTING).getValue();
        for (XdJob job : jobRepository.findAll()) {
            String name = job.getName();
            if (log.isDebugEnabled()) {
                log.debug("Deleting job definition: " + api + "jobs/definitions/" + name + "job");
            }
            try {
                restTemplate.delete(api + "jobs/definitions/" + name + "job");
            } catch (RestClientException e) {
                log.warn("Job " + name + " already deleted perhaps; " + e.getMessage(), e);
            }

            if (log.isDebugEnabled()) {
                log.debug("Deleting module: " + api + "modules/job/" + name);
            }
            try {
                restTemplate.delete(api + "modules/job/" + name);
            } catch (RestClientException e) {
                log.warn("Module " + name + " already deleted perhaps; " + e.getMessage(), e);
            }
            jobRepository.delete(job);
        }
        for (Stream stream : streamRepository.findAll()) {
            String name = stream.getName();
            try {
                restTemplate.delete(api + "streams/definitions/" + name);
            } catch (RestClientException e) {
                log.warn("Stream " + name + " already deleted perhaps; " + e.getMessage(), e);
            }
            streamRepository.delete(stream);
        }
        return "Successfully removed all streams";
    }

    @RequestMapping(value = "/api/xd/redeploy", method = RequestMethod.PUT)
    public @ResponseBody String deployEverything() {
        for (XdJob job : jobRepository.findAll()) {
            deploy(job);
        }
        for (Stream stream : streamRepository.findAll()) {
            deploy(stream);
        }
        return "Successfully redeployed everything";
    }

    @RequestMapping(value = "/api/xd/{namespace}/redeploy", method = RequestMethod.PUT)
    public @ResponseBody String deployNamespace(@PathVariable("namespace") String namespace) {
        for (Stream stream : streamRepository.findByNamespace(namespace)) {
            deploy(stream);
        }
        return "Successfully redeployed namespace " + namespace;
    }

    @RequestMapping(value = "/api/xd/{namespace}/undeploy", method = RequestMethod.PUT)
    public @ResponseBody String undeployNamespace(@PathVariable("namespace") String namespace) {
        for (Stream stream : streamRepository.findByNamespace(namespace)) {
            undeploy(stream);
        }
        return "Successfully undeployed namespace " + namespace;
    }

    @RequestMapping(value = "/api/streams/{streamId}/deploy", method = RequestMethod.PUT)
    public @ResponseBody String deployStream(@PathVariable("streamId")Integer streamId) {
        Stream stream = streamRepository.findOne(streamId);
        return deploy(stream);
    }

    @RequestMapping(value = "/api/stream-namespaces", method = RequestMethod.GET)
    public @ResponseBody List<String> streamNamespaces() {
        Set<String> namespaces = new HashSet<String>();
        for (Stream stream : streamRepository.findAll()) {
            String namespace = stream.getNamespace();
            if (namespace != null && !namespace.isEmpty()) {
                namespaces.add(namespace);
            }
        }
        List<String> namespaceList = new ArrayList<String>(namespaces);
        Collections.sort(namespaceList);
        return namespaceList;
    }

    private String deploy(XdJob job) {
        String api = settingRepository.findOne(SPRING_XD_API_SETTING).getValue();
        String name = job.getName();
        if (log.isDebugEnabled()) {
            log.debug("Deleting job definition: " + api + "jobs/definitions/" + name + "job");
        }
        try {
            restTemplate.delete(api + "jobs/definitions/" + name + "job");
        } catch (RestClientException e) {
            log.warn("Job " + name + "job already deleted perhaps; " + e.getMessage(), e);
        }

        String definition = name + " --makeUnique=" + Boolean.toString(job.isMakeUnique());
        MultiValueMap<String, String> values = new LinkedMultiValueMap<String, String>();
        values.add("name", name + "job");
        values.add("definition", definition);
        HttpHeaders jobHeaders = new HttpHeaders();
        jobHeaders.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        HttpEntity<MultiValueMap<String, String>> jobEntity = new HttpEntity<MultiValueMap<String, String>>(values, jobHeaders);
        if (log.isDebugEnabled()) {
            log.debug("Creating job definition " + definition);
        }
        try {
            restTemplate.postForObject(api + "jobs/definitions", jobEntity, Object.class);
        } catch (RestClientException e) {
            log.error(e.getMessage(), e);
            return e.getMessage();
        }

        return "Successfully (re)deployed " + name + "job";
    }

    private String getSetting(String key) {
        Setting setting = settingRepository.findOne(key);
        return (setting == null ? null : setting.getValue());
    }

    private String replaceVar(String str, String var, String value) {
        if (value == null) return str;
        str = str.replace("$" + var, value);
        str = str.replace("${" + var + "}", value);
        return str;
    }

    private String deploy(Stream stream) {
        String api = getSetting(SPRING_XD_API_SETTING);
        String scriptsDir = getSetting(SCRIPTS_DIR_SETTING);
        String sftpHost = getSetting(SFTP_HOST);
        String localLandingDir = getSetting(LOCAL_LANDING_DIR);
        String sftpUser = getSetting(SFTP_USER);
        String sftpPassword = getSetting(SFTP_PASSWORD);
        String definition = stream.getDefinition();
        if (definition == null) {
            StringBuilder sb = new StringBuilder();
            sb.append("file --dir=").append(stream.getPollingDirectory())
                    .append(" --pattern=").append(stream.getFilenamePattern())
                    .append(" --preventDuplicates=").append(stream.isPreventDuplicates())
                    .append(" --mode=ref --fixedDelay=15 | filter --expression='!(payload.getAbsolutePath().endsWith(\".filepart\") || payload.getAbsolutePath().endsWith(\".cxp\") || payload.getAbsolutePath().endsWith(\".processing\"))' | script --script=file://").append(scriptsDir).append("processing.groovy > queue:job:")
                    .append(stream.getJob());
            definition = sb.toString();
        } else {
            definition = replaceVar(definition, "scriptsDir", scriptsDir);
            definition = replaceVar(definition, "sftpHost", sftpHost);
            definition = replaceVar(definition, "localLandingDir", localLandingDir);
            definition = replaceVar(definition, "sftpUser", sftpUser);
            definition = replaceVar(definition, "sftpPassword", sftpPassword);
        }
        log.info(definition);
        String name = stream.getName();
        try {
            restTemplate.delete(api + "streams/definitions/" + name);
        } catch (RestClientException e) {
            log.warn("Stream " + name + " already deleted perhaps; " + e.getMessage(), e);
        }

        MultiValueMap<String, Object> values = new LinkedMultiValueMap<String, Object>();
        values.add("name", name);
        values.add("definition", definition);
        values.add("deploy", Boolean.toString(true)); // default anyway

//        StreamDefinitionResource resource = restTemplate.postForObject(api + "streams/definitions",
//                values,
//                StreamDefinitionResource.class);
        restTemplate.postForObject(api + "streams/definitions", values, Object.class);

        return "Successfully (re)deployed stream " + name;
    }

    private String undeploy(Stream stream) {
        String api = getSetting(SPRING_XD_API_SETTING);
        String name = stream.getName();
        restTemplate.delete(api + "streams/deployments/" + name);
        return "Successfully undeployed stream " + name;
    }
}
