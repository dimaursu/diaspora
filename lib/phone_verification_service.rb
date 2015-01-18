class PhoneVerificationService
  attr_reader :user

  def initialize(options)
    @user = User.find(options[:user_id])
  end

  def process
    send_sms
  end

  private

  def to
    "#{user.profile.phone}"
  end

  def body
    "Introdu codul '#{user.phone_verification_code}' pentru a valida profilul"
  end

  def sms_gateway
    "http/sendmsg?user=timonovici&password=#{ENV["SMS_GWP"]}&api_id=3519684&to=#{to}&text=#{body}"
  end

  def send_sms
    Rails.logger.info "SMS: To: #{to} Body: \"#{body}\""
    conn = Faraday.new(url: 'http://api.clickatell.com/')
    conn.get sms_gateway
  end
end
