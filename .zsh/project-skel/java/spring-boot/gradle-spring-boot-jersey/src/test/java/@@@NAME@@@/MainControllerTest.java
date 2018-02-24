package @@@NAME@@@;

import org.junit.Test;
import org.junit.runner.RunWith;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.test.context.junit4.SpringRunner;

import static org.assertj.core.api.Assertions.assertThat;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
public class MainControllerTest {

	@Autowired
	private TestRestTemplate restTemplate;

	@Test
	public void rootReturnsHelloWorld() {
		assertThat(this.restTemplate.getForObject("/", String.class))
				.isEqualTo("@@@ARTIFACT_ID@@@");
	}

}
