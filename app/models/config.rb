class Config < Settingslogic
  source "#{Rails.root}/config/astrochimp.yml"
  namespace Rails.env
end
