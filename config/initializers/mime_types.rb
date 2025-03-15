# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

# Register Turbo Stream MIME type if not already registered by Turbo Rails
unless Mime::Type.lookup_by_extension(:turbo_stream)
  Mime::Type.register "text/vnd.turbo-stream.html", :turbo_stream
end
