class PhoneVerificationService
  attr_reader :user

  def initialize(options)
    @profile = options
  end

  def process
    send_sms
  end

  private

  def to
    "#{@profile.phone}"
  end

  def body
    "Introdu codul '#{@profile.phone_v_code}' pentru a valida profilul"
  end

  def sms_gateway
    sms_gw = AppConfig.environment.sms_gateway.to_h
    "http/sendmsg?user=#{sms_gw['user']}&password=#{sms_gw['pass']}&api_id=#{sms_gw['appid']}&to=#{to}&text=#{body}"
  end

  def send_sms
    Rails.logger.info "SMS: To: #{to} Body: \"#{body}\""
    conn = Faraday.new(url: 'http://api.clickatell.com/')
    conn.get sms_gateway
  end
end
