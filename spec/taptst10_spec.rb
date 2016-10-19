require 'spec_helper'
require 'taptst10'

describe Taptst10 do
  it 'has a version number' do
    expect(Taptst10::VERSION).not_to be nil
  end

  context 'device is connected' do
    before { @usb = Taptst10::Usb.new }

    describe '#open' do
      it 'raises no error' do
        expect { @usb.open }.to_not raise_error
      end
    end
  end

  context 'device is connected' do
    # before { @access = Taptst10::Access.new }

    describe '#all_records' do
      it 'raises no error' do
        expect { Taptst10::Access.all_records }.to_not raise_error
      end
    end
  end

end
