require 'csv'
class CsvArray < Array

  def to_csv options = {}
    CSV.generate(options) do |csv|
      self.each do |element|
        csv << [element[:value], element[:message]]
      end
    end
  end

end
