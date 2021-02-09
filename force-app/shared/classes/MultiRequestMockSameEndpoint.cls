public class MultiRequestMockSameEndpoint implements HttpCalloutMock {
    private Integer m_responseIndex;
    private String[] m_responses;

    public MultiRequestMockSameEndpoint(List<String> responses) {
        m_responseIndex = 0;
        m_responses = responses;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        // Return the next response in the list
        String response = m_responses[m_responseIndex];
        m_responseIndex++;

        res.setBody(response);
        res.setStatusCode(200);

        return res;
    }
}
