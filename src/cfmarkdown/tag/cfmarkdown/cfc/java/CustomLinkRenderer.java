import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import org.pegdown.LinkRenderer;
import org.pegdown.ast.WikiLinkNode;

public class CustomLinkRenderer extends LinkRenderer {

    @Override
    public Rendering render(WikiLinkNode node) {
        String[] withPipes = node.getText().split("\\|");
        if(withPipes.length > 1) {
	        return new Rendering(withPipes[1].replace(' ', '-'), withPipes[0]);
        } else {
			try {
	            String url = "./" + URLEncoder.encode(node.getText().replace(' ', '-'), "UTF-8") + ".html";
	            return new Rendering(url, node.getText());
	        } catch (UnsupportedEncodingException e) {
	            throw new IllegalStateException();
	        }
        }
    }

}