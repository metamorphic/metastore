package metastore;

import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Workaround for running the front-end on a different port.
 *
 * @author Mark Moloney <markmo @ metamorphic.io>
 * Copyright 2015
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class CORSFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletResponse res = (HttpServletResponse)response;

        // TODO
        // required when implementing login
        //res.setHeader("Access-Control-Allow-Origin", System.getenv("ACCESS_ALLOW_CONTROL_ORIGIN"));
        //res.setHeader("Access-Control-Allow-Credentials", "true");

        res.setHeader("Access-Control-Allow-Origin", "*");
        res.setHeader("Access-Control-Allow-Methods", "POST, PUT, PATCH, GET, OPTIONS, DELETE");
        res.setHeader("Access-Control-Allow-Headers", "authorization, x-requested-with, Content-Type, Accept, Cache-Control, Location");
        res.setHeader("Access-Control-Max-Age", "3600");
        res.setHeader("Access-Control-Expose-Headers", "Location");
        HttpServletRequest req = (HttpServletRequest)request;
        if (!"OPTIONS".equals(req.getMethod())) {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {}
}
