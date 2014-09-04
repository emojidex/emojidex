
module Emojidex
  # Asset Information for Collections
  module CollectionAssetInformation
    def generate_checksums(formats = Emojidex::Defaults.formats, sizes = Emojidex::Defaults.sizes)
      @emoji.values.each do |moji|
        moji.checksum = get_checksum(moji, formats, sizes)
      end
    end
  end

  def get_checksum(moji, formats = Emojidex::Defaults.formats, sizes = Emojidex::Defaults.sizes)
    sums = {}
    sums[:svg] = _checksum_for_file("#{@vector_path}/#{moji.code}.svg") if formats.contain :svg
  end

  def generate_paths(formats = Emojidex::Defaults.formats, sizes = Emojidex::Defaults.sizes)

  end

  private

  def _checksum_for_file(path)
    File.exist? path ? Digest::MD5.file(path).hexdigest : nil
  end
end
