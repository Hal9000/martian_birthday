class UrlParse

  def initialize(url)
    @url_string = url
  end
  
  def parse
    data = {name: '', birthday: ''}
    if self.validate_url()
      prs_data = @url_string.match(/(?<name>\S*?)[-]{0,1}martian-birthday-on-(?<birthday>\S*)/)
      data = { name: prs_data[:name], birthday: prs_data[:birthday]}
    end
    data
  end

  def validate_url
    true if @url_string.match(/martian-birthday-on/)
  end
end