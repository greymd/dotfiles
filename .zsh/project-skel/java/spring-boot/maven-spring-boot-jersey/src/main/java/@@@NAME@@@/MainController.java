package @@@NAME@@@;

import javax.ws.rs.GET;
import javax.ws.rs.Path;

@Path("/")
public class MainController {
    @GET
    public String index() {
        return "@@@ARTIFACT_ID@@@";
    }
}
