@IsTest
public class MultiRequestMockSameEndpointTest {
    @IsTest
    static void testRespondMethod() {
        // Create a list of responses
        List<String> responses = new List<String>();
        responses.add('{"message":"Response 1"}');
        responses.add('{"message":"Response 2"}');
        responses.add('{"message":"Response 3"}');

        // Create an instance of MultiRequestMockSameEndpoint
        MultiRequestMockSameEndpoint mock = new MultiRequestMockSameEndpoint(responses);

        // Create a mock HTTP request
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://example.com');
        request.setMethod('GET');

        // Call the respond method and capture the HTTP response
        HttpResponse response = mock.respond(request);

        // Verify the response
        System.assertEquals('{"message":"Response 1"}', response.getBody());
        System.assertEquals(200, response.getStatusCode());

        // Call the respond method again and capture the HTTP response
        response = mock.respond(request);

        // Verify the response
        System.assertEquals('{"message":"Response 2"}', response.getBody());
        System.assertEquals(200, response.getStatusCode());

        // Call the respond method for the third time and capture the HTTP response
        response = mock.respond(request);

        // Verify the response
        System.assertEquals('{"message":"Response 3"}', response.getBody());
        System.assertEquals(200, response.getStatusCode());
    }
}
