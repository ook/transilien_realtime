module TransilienRealtime
  class Train
    attr_reader :mission, :departure_at, :terminus, :numero

    class << self
      def from_xml(xml_node)
        mission = xml_node.xpath('//miss').first.text
        terminus = xml_node.xpath('//term').first.text
        numero = xml_node.xpath('//num').first.text
        date_node = xml_node.xpath('//date').first
        departure_at = DateTime.strptime(date_node.text, '%d/%m/%Y %H:%M')
        mode = date_node.attr('mode')
        train = new.freeze
      end
    end
  end
end
