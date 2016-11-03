package metastore.controllers;

import metastore.models.FeatureType;
import metastore.models.FeatureTypeClientProjection;
import metastore.repositories.FeatureTypeRepository;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.core.projection.ProjectionFactory;
import org.springframework.data.rest.core.projection.ProxyProjectionFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by markmo on 2/11/2016.
 */
@RestController
public class FeatureTypeController {

    private static final Log log = LogFactory.getLog(FeatureTypeController.class);

    @Autowired
    private BeanFactory beanFactory;

    @Autowired
    FeatureTypeRepository featureTypeRepository;

    @RequestMapping(value = "/api/feature-types-all", method = RequestMethod.GET)
    public @ResponseBody Iterable<FeatureTypeClientProjection> findAll() {
        if (log.isDebugEnabled()) {
            log.debug("Returning all feature types");
        }
        Iterable<FeatureType> featureTypes = featureTypeRepository.findAll();
        ProjectionFactory projectionFactory = new ProxyProjectionFactory(beanFactory);
        List<FeatureTypeClientProjection> projected = new ArrayList<>();
        for (FeatureType featureType : featureTypes) {
            projected.add(projectionFactory.createProjection(featureType, FeatureTypeClientProjection.class));
        }
        return projected;
    }
}
