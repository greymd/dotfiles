package @@@NAME@@@;

import org.glassfish.jersey.server.ResourceConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.stereotype.Component;

@ComponentScan
@SpringBootApplication
public class Application {
    @Component
    static class JerseryConfig extends ResourceConfig {
        public JerseryConfig() {
            register(MainController.class);
        }
    }
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
