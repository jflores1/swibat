module EncodeHelper
  
  def parse_text(param_string, parse_bbcode = true)
    local = "" + param_string
    strip_html(local)
    parse_bbcode(local) if parse_bbcode == true
    parse_spacing(local)
    return local
  end

  private
  
  # escape < and > to remove any html
  def strip_html(param_string)
    param_string.gsub!('<', '&lt;')
    param_string.gsub!('>', '&gt;')
    param_string.gsub(/\"/,"&quot;")
    return param_string
  end
  
  # convert the special characters inbetween the [code] tags to html code, 
  # so they don't get parsed as bbcode
  def strip_bbcode(text)
    text.gsub!("[code]", "")
    text.gsub!("[/code]", "")
    text.gsub!("8", "&#56;") 
    text.gsub!("[", "&#91;")
    text.gsub!("]", "&#93;")
    text.gsub!(".", "&#46;")
    text.gsub!(":", "&#58;")
    text.gsub!(";)", "&#59;&#41;")
    
    return text   
  end
  
  # turn new lines into <br /> to format the spacing properly
  def parse_spacing(param_string)
    param_string.gsub!( /\r\n?/, "\n" )
    param_string.gsub!( /\n/, "<br />" )
    return param_string
  end  
 
  def parse_bbcode(param_string)
    # code
    param_string.gsub!( /\[code\](.*?)\[\/code\]/im ) {|s| '<pre>' + strip_bbcode(s) + '</pre>' }    
    
    # Align
    param_string.gsub!( /\[center\]((.|\n)*?)\[\/center\]/i, '<center>\1</center>' )  
    
    # Simple Text Styling
    param_string.gsub!( /\[b\](.*?)\[\/b\]/im, '<strong>\1</strong>' )
    param_string.gsub!( /\[u\](.*?)\[\/u\]/im, '<u>\1</u>' )
    param_string.gsub!( /\[i\](.*?)\[\/i\]/im, '<em>\1</em>' )
    param_string.gsub!( /\[h1\](.*?)\[\/h1\]/im, '<h1>\1</h1>' )
    param_string.gsub!( /\[h2\](.*?)\[\/h2\]/im, '<h2>\1</h2>' )
    param_string.gsub!( /\[h3\](.*?)\[\/h3\]/im, '<h3>\1</h3>' )
    param_string.gsub!( /\[s\](.*?)\[\/s\]/im, '<span style="text-decoration: line-through" >\1</span>' )
    param_string.gsub!( /\[hr\]/im, '<hr />' )
    
    # lists
    param_string.gsub!( /\[ol\](.*?)\[\/ol\]/mi, '<ol>\1</ol>' )
    param_string.gsub!( /\[ul\](.*?)\[\/ul\]/mi, '<ul>\1</ul>' )
    param_string.gsub!( /\[list\](.*?)\[\/list\]/mi, '<ul>\1</ul>' )
    param_string.gsub!( /\[li\](.*?)\[\/li\]/mi, '<li>\1</li>' )
    
    # urls    
    param_string.gsub!( /\[url=(.*?)\](.*?)\[\/url\]/mi, '<a href="\1" rel="nofollow" target="_blank" >\2</a>' )    
    param_string.gsub!( /\[url\](.*?)\[\/url\]/mi, '<a href="\1" rel="nofollow" target="_blank" >\1</a>' )    
    param_string.gsub!( /(\A|\s)((https?:\/\/)[^\s<]+)/, ' <a href="\2" rel="nofollow" target="_blank" >\2</a>' )
    param_string.gsub!( /(\A|\s)((www\.)[^\s<]+)/, ' <a href="http://\2" rel="nofollow" target="_blank" >\2</a>' )
    
    # email
    param_string.gsub!( /\[email=(.*?)\](.*?)\[\/email\]/mi, '<a href="mailto:\1" rel="nofollow" target="_blank" >\2</a>' )    
    
    return param_string
  end
end