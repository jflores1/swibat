PDFKit.configure do |config|
   # config.wkhtmltopdf = '/usr/local/bin/wkhtmltopdf'
   config.default_options = {
     :page_size     => 'Letter',
     :margin_top    => '0.5in',
     :margin_right  => '1.0in',
     :margin_bottom => '0.5in',
     :margin_left   => '1.0in'
     :print_media_type => true
   }
  # config.root_url = "http://localhost" # Use only if your external hostname is unavailable on the server.
end