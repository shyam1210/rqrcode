# This class creates a SVG files.
# Code from: https://github.com/samvincent/rqrcode-rails3
module RQRCode
  module Export

    module SVG

      # Render the SVG from the Qrcode.
      #
      # Options:
      # offset - Padding around the QR Code (e.g. 10)
      # fill - Background color (e.g "ffffff" or :white)
      # color - Foreground color for the code (e.g. "000000" or :black)
      # module_size - The Pixel size of each module (e.g. 11)
      # shape_rendering - Defaults to crispEdges
      #
      def as_svg(options={})
        offset = options[:offset].to_i || 0
        color = options[:color] || "000"
        shape_rendering = options[:shape_rendering] || "crispEdges"
        module_size = options[:module_size] || 11
        text_in_image = options[:text_in_image] || {}

        # height and width dependent on offset and QR complexity
        dimension = options[:dimension] || (self.module_count*module_size) + (2*offset)

        xml_tag = %{<?xml version="1.0" standalone="yes"?>}
        open_tag = %{<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ev="http://www.w3.org/2001/xml-events" width="#{dimension}" height="#{dimension}" shape-rendering="#{shape_rendering}">}
        close_tag = "</svg>"

        result = []
        self.modules.each_index do |c|
          tmp = []
          self.modules.each_index do |r|
            y = c*module_size + offset
            x = r*module_size + offset

            next unless self.is_dark(c, r)
            tmp << %{<rect width="#{module_size}" height="#{module_size}" x="#{x}" y="#{y}" style="fill:##{color}"/>}
          end
          result << tmp.join
        end

        if options[:fill]
          result.unshift %{<rect width="#{dimension}" height="#{dimension}" x="0" y="0" style="fill:##{options[:fill]}"/>}
        end

        if text_in_image
          text = %{<text x="#{text_in_image[:x]}" y="#{text_in_image[:y]}" fill="#{text_in_image[:fill_color]}">#{text_in_image[:text]}</text>}
        end

        [xml_tag, open_tag, result, text, close_tag].flatten.join("\n")
      end
    end
  end
end

RQRCode::QRCode.send :include, RQRCode::Export::SVG
