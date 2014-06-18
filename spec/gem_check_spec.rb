require 'spec_helper'

describe Emojidex::GemCheck do

  describe '.bundle_install_path' do
    it 'check the file exists from bundle install files.' do
      path = Emojidex::GemCheck.bundle_install_path 'emojidex-vectors'
      expect(path.class).to eq String
    end
  end

  describe '.install_path' do
    it 'get the file path from local gem.' do
      path = Emojidex::GemCheck.install_path 'emojidex-vectors'
      expect(path.class).to eq Array
    end
  end

end
