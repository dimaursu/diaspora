class PhoneVerificationService
  attr_reader :user

  def initialize(options)
    @profile = User.find(options[:user_id]).profile
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
    "http/sendmsg?" +
    "user=#{Rails.application.secrets.sms_gateway_user}" +
    "&password=#{Rails.application.secrets.sms_gateway_password}" +
    "&api_id=#{Rails.application.secrets.sms_gateway_appid}" +
    "&to=#{to}&text=#{body}"
  end

  def send_sms
    Rails.logger.info "SMS: To: #{to} Body: \"#{body}\""
    conn = Faraday.new(url: 'http://api.clickatell.com/')
    conn.get sms_gateway
  end
end
