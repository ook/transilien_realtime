module TransilienRealtime
  class Train
    include Comparable
    attr_reader :mission, :departure_at, :terminus, :numero, :mode

    class << self
      def from_xml(xml_node)
        attr = {}
        attr[:mission] = xml_node.xpath('//miss').first.text
        attr[:terminus] = xml_node.xpath('//term').first.text
        attr[:numero] = xml_node.xpath('//num').first.text
        date_node = xml_node.xpath('//date').first
        attr[:departure_at] = DateTime.strptime(date_node.text, '%d/%m/%Y %H:%M').to_time
        attr[:mode] = date_node.attr('mode')
        train = new(attr).freeze
      end
    end

    def initialize(mission:, departure_at:, terminus:, numero:, mode:)
      @mission = mission
      @numero = numero
      @departure_at = departure_at
      @terminus = terminus
    end

    def to_json(options={})
      { mission: mission, departure_at: departure_at, numero: numero, terminus: terminus, mode: mode }
    end

    def <=>(other)
      return 0 if mission == other.mission &&
                  departure_at == other.departure_at &&
                  terminus == other.terminus &&
                  numero == other.numero &&
                  mode == other.mode
      departure_at <=> other.departure_at
    end

  end
end
