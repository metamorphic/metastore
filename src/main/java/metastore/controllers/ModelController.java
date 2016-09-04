package metastore.controllers;

import metastore.models.AnalyticalModel;
import metastore.repositories.AnalyticalModelRepository;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.eclipse.egit.github.core.Repository;
import org.eclipse.egit.github.core.RepositoryCommit;
import org.eclipse.egit.github.core.RepositoryContents;
import org.eclipse.egit.github.core.client.GitHubClient;
import org.eclipse.egit.github.core.client.PageIterator;
import org.eclipse.egit.github.core.service.CommitService;
import org.eclipse.egit.github.core.service.ContentsService;
import org.eclipse.egit.github.core.service.RepositoryService;
import org.eclipse.egit.github.core.service.UserService;
import org.eclipse.egit.github.core.util.EncodingUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.rest.webmvc.PersistentEntityResource;
import org.springframework.data.rest.webmvc.PersistentEntityResourceAssembler;
import org.springframework.data.rest.webmvc.RepositoryRestController;
import org.springframework.data.web.PagedResourcesAssembler;
import org.springframework.hateoas.PagedResources;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Collection;
import java.util.List;

/**
 * Created by markmo on 1/08/2015.
 */
@RepositoryRestController
public class ModelController {

    private static final Log log = LogFactory.getLog(ModelController.class);

    @Autowired
    private AnalyticalModelRepository modelRepository;

    // must be autowired in as a class member instead of resolved as a method
    // arg, otherwise
    //NoSuchMethodException: org.springframework.data.rest.webmvc.PersistentEntityResourceAssembler.<init>()
    @Autowired
    private PagedResourcesAssembler pagedResourcesAssembler;

    // http://stackoverflow.com/questions/26538156/can-i-make-a-custom-controller-mirror-the-formatting-of-spring-data-rest-sprin
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "models", method = RequestMethod.GET)
    @ResponseBody
    public PagedResources<PersistentEntityResource> index(Pageable pageable,
                                                          PersistentEntityResourceAssembler persistentEntityResourceAssembler) {
        if (log.isDebugEnabled()) {
            log.debug("ModelController.index called");
        }
        Page<AnalyticalModel> page = modelRepository.findAll(pageable);
        return pagedResourcesAssembler.toResource(page, persistentEntityResourceAssembler);
    }

    @RequestMapping(value = "models", method = RequestMethod.POST)
    @ResponseBody
    public String create(@RequestBody AnalyticalModel model) {
        if (log.isDebugEnabled()) {
            log.debug("ModelController.create called");
        }
        try {
            GitHubClient client = new GitHubClient();
            client.setCredentials("markmo", "boxcar99");
            RepositoryService service = new RepositoryService();
            Repository repo = service.getRepository("markmo", model.getName());
            if (log.isDebugEnabled()) {
                log.debug("Repo: " + repo.getName());
            }
            model.setCommitter("markmo");
            UserService userService = new UserService(client);
            List<String> emails = userService.getEmails();
            if (!emails.isEmpty()) {
                model.setContactPerson(emails.get(0));
            }
            CommitService commitService = new CommitService();
            PageIterator<RepositoryCommit> it = commitService.pageCommits(repo, 1);
            if (it.hasNext()) {
                Collection<RepositoryCommit> page = it.next();
                if (!page.isEmpty()) {
                    RepositoryCommit commit = page.iterator().next();
                    model.setVersion(commit.getSha());
                }
            }
            ContentsService contentsService = new ContentsService();
            RepositoryContents readme = contentsService.getReadme(repo);
            String readmeText = new String(EncodingUtils.fromBase64(readme.getContent()));
            if (log.isDebugEnabled()) {
                log.debug(readmeText);
            }
            model.setDescription(readmeText);
            if (log.isDebugEnabled()) {
                log.debug("Saving model");
            }
            modelRepository.save(model);
        } catch (Exception e) {
            log.error(e.getMessage(), e);
            e.printStackTrace();
        }
        return "OK";
    }
}
