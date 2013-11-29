require 'csv'
class CsvArray < Array

  def to_csv options = {}
    CSV.generate(options) do |csv|
      self.each do |element|
        csv << element
      end
    end
  end

end
