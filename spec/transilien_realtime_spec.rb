require 'spec_helper'

describe TransilienRealtime do
  it 'has a version number' do
    expect(TransilienRealtime::VERSION).not_to be nil
  end

  describe TransilienRealtime::Base do
    let(:trb) { TransilienRealtime::Base.new }

    it { expect { trb.next(from: nil) }.to raise_error ArgumentError }

    context 'w/o connection, return nil for all outputs' do
      it { expect(trb.xml).to eq(nil) }
      it { expect(trb.json).to eq(nil) }
      it { expect(trb.response).to eq(nil) }
      it { expect(trb.body).to eq(nil) }
      it { expect(trb.content).to eq(nil) }
    end

    context 'with faked connections PSLVAR' do
      before(:each) do
        allow(trb).to receive(:xml_document).and_return(Nokogiri::XML(PSLVAR))
      end

      it 'count parse Train instances correctly' do
        expect(trb.trains.length).to eq(2)
        expect(trb.trains.all? { |t| t.is_a?(TransilienRealtime::Train) }).to eq(true)
      end

      it 'serialize to_json gently' do
        trb.trains
        expect(trb.json).to eq("[{\"mission\":\"GOCA\",\"departure_at\":\"2015-05-14 20:27:00 +0000\",\"numero\":\"137153\",\"terminus\":\"87381244\",\"mode\":\"realtime\"},{\"mission\":\"MOCA\",\"departure_at\":\"2015-05-14 20:42:00 +0000\",\"numero\":\"136955\",\"terminus\":\"87381509\",\"mode\":\"realtime\",\"state\":\"cancelled\"}]")
      end
    end

    context 'with faked connections VARPSL' do
      before(:each) do
        allow(trb).to receive(:xml_document).and_return(Nokogiri::XML(VARPSL))
      end

      it 'count parse Train instances correctly' do
        expect(trb.trains.length).to eq(14)
        expect(trb.trains.all? { |t| t.is_a?(TransilienRealtime::Train) }).to eq(true)
      end
    end
      
  end

  describe TransilienRealtime::Train do
    context '.from_xml' do
      let(:expected_train) do
        TransilienRealtime::Train.new(
                                       mission: 'GOCA',
                                       terminus: '87381244',
                                       numero: '137153',
                                       mode: 'R',
                                       state: 'S',
                                       departure_at: '14/05/2015 20:27'
                                     )
      end
      let(:train_node) { Nokogiri::XML(PSLVAR).xpath('//train').first }
      subject { TransilienRealtime::Train }  
      it { expect(subject.from_xml(train_node)).to eq(expected_train) }
    end

    context '.to_json' do
      let(:train_node) { Nokogiri::XML(PSLVAR).xpath('//train')[1] }
      subject { TransilienRealtime::Train }  
      it { expect(subject.from_xml(train_node).to_json).to eq('{"mission":"MOCA","departure_at":"2015-05-14 20:42:00 +0000","numero":"136955","terminus":"87381509","mode":"realtime","state":"cancelled"}') }
    end
  end

  PSLVAR = <<-RAW
    <?xml version="1.0" encoding="UTF-8"?>
    <passages gare="87384008">
        <train>
            <date mode="R">14/05/2015 20:27</date>
            <num>137153</num>
            <miss>GOCA</miss>
            <term>87381244</term>
        </train>
        <train>
            <date mode="R">14/05/2015 20:42</date>
            <num>136955</num>
            <miss>MOCA</miss>
            <etat>S</etat>
            <term>87381509</term>
        </train>
    </passages>
  RAW

  VARPSL = <<-RAW
    <?xml version="1.0" encoding="UTF-8"?>
    <passages gare="87381798">
        <train>
            <date mode="R">14/05/2015 20:41</date>
            <num>131150</num>
            <miss>POCI</miss>
            <term>87384008</term>
        </train>
        <train>
            <date mode="R">14/05/2015 20:56</date>
            <num>137954</num>
            <miss>PIZA</miss>
            <term>87384008</term>
        </train>
        <train>
            <date mode="R">14/05/2015 21:11</date>
            <num>136652</num>
            <miss>PACA</miss>
            <term>87384008</term>
        </train>
        <train>
            <date mode="R">14/05/2015 21:26</date>
            <num>137962</num>
            <miss>PIZA</miss>
            <term>87384008</term>
        </train>
        <train>
            <date mode="R">14/05/2015 21:41</date>
            <num>136660</num>
            <miss>PACA</miss>
            <term>87384008</term>
        </train>
        <train>
            <date mode="R">14/05/2015 21:56</date>
            <num>137964</num>
            <miss>PIZA</miss>
            <term>87384008</term>
        </train>
        <train>
            <date mode="R">14/05/2015 22:11</date>
            <num>136662</num>
            <miss>PACA</miss>
            <term>87384008</term>
        </train>
        <train>
            <date mode="R">14/05/2015 22:26</date>
            <num>137972</num>
            <miss>PIZA</miss>
            <term>87384008</term>
        </train>
        <train>
            <date mode="R">14/05/2015 22:41</date>
            <num>136670</num>
            <miss>PACA</miss>
            <term>87384008</term>
        </train>
        <train>
            <date mode="R">14/05/2015 23:00</date>
            <num>137974</num>
            <miss>PORA</miss>
            <term>87384008</term>
        </train>
        <train>
            <date mode="R">14/05/2015 23:11</date>
            <num>136672</num>
            <miss>PACA</miss>
            <term>87384008</term>
        </train>
        <train>
            <date mode="R">14/05/2015 23:30</date>
            <num>137982</num>
            <miss>PORA</miss>
            <term>87384008</term>
        </train>
        <train>
            <date mode="R">14/05/2015 23:41</date>
            <num>136680</num>
            <miss>PACA</miss>
            <term>87384008</term>
        </train>
        <train>
            <date mode="R">15/05/2015 00:00</date>
            <num>137984</num>
            <miss>PORA</miss>
            <term>87384008</term>
        </train>
    </passages>
  RAW
end
