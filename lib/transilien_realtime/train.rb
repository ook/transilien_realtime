module TransilienRealtime
  class Train
    include Comparable

    MODES  = {
               'R' => 'realtime',
               'T' => 'theoritical'
             }
    STATES = {
               'R' => 'late',
               'S' => 'cancelled',
             }

    attr_reader :mission, :departure_at, :terminus, :numero, :mode, :state

    class << self
      def from_xml(xml_node)
        attr = {}
        attr[:mission] = xml_node.xpath('//miss').first.text
        attr[:terminus] = xml_node.xpath('//term').first.text
        attr[:numero] = xml_node.xpath('//num').first.text
        date_node = xml_node.xpath('//date').first
        attr[:departure_at] = date_node.text
        attr[:mode] = date_node.attr('mode')
        etat = date_node.xpath('//etat').first
        attr[:state] = etat.text if etat
        train = new(attr).freeze
      end
    end

    def initialize(mission:, departure_at:, terminus:, numero:, mode:, state: nil)
      @mission = mission
      @numero = numero
      @departure_at = DateTime.strptime(departure_at, '%d/%m/%Y %H:%M').to_time
      @terminus = terminus
      @mode = MODES[mode]
      @state = STATES[state]
    end

    def to_json(options={})
      json = { mission: mission, departure_at: departure_at, numero: numero, terminus: terminus, mode: mode }
      json[:state] = state if state
      json.to_json
    end

    def <=>(other)
      return 0 if mission == other.mission &&
                  departure_at == other.departure_at &&
                  terminus == other.terminus &&
                  numero == other.numero &&
                  mode == other.mode && 
                  state == other.state
      departure_at <=> other.departure_at
    end

  end
end
