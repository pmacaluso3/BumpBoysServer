require 'houston'

class ServersController < ApplicationController
  def run
    feet_in_one_lat = 364402.01
    feet_in_one_lon = 272541.72
    # i = 0
    # loop do
      # building a mutual contact list for each user
      @users = User.all
      @mutual_contacts_master = {}
      @users.each do |user|
        @mutual_contacts_master[user.token] = []
        mutual_users = user.contacts_who_are_also_users.map {|e|e.corresponding_user}
        mutual_users.each do |m_u|
          if m_u.has_as_contact?(user)
            @mutual_contacts_master[user.token] << m_u
          end
        end
      end

      # determining the distance to each mutual contact for each user
      @relationships = {}
      @mutual_contacts_master.each do |user_token, mutual_contacts_list|
        @relationships[user_token] = {}
        @user = User.find_by(token: user_token)
        mutual_contacts_list.each do |mutual_contact|
          d_lat = mutual_contact.lat - @user.lat
          d_lon = mutual_contact.lon - @user.lon
          d_lat_in_feet = d_lat * feet_in_one_lat
          d_lon_in_feet = d_lon * feet_in_one_lon
          distance = (d_lat_in_feet**2 + d_lon_in_feet**2)**0.5
          @relationships[user_token][mutual_contact.token] = distance
          # @relationships[user_token]["first_name"] = mutual_contact.first_name
          # @relationships[user_token]["last_name"] = mutual_contact.last_name
          # @relationships[user_token]["image_url"] = mutual_contact.image_url
          # @relationships[user_token]["udid"] = mutual_contact.udid
        end
      end

      # for each user, prepare the string of image urls for the mutual contacts within 1000 feet of that user
      # also, create an array of the tokens of all of this user's nearby friends
      @relationships.each do |user_token, mutual_contacts_list|
        this_users_nearby_friends_images = []
        this_users_nearby_friends_tokens = []
        this_users_nearby_friends_tokens_previous = User.find_by(token: user_token).nearby_friends_tokens.split(",")
        mutual_contacts_list.each do |mutual_contact_token, distance|
          if distance < 1000
            this_users_nearby_friends_images << User.find_by(token: mutual_contact_token).image_url
            this_users_nearby_friends_tokens << mutual_contact_token
          end
        end
        User.find_by(token: user_token).nearby_friends_images = this_users_nearby_friends_images.join(",")

        # determine which friends are new to this user's radius, and send this user an apn for each one
        # finally, set this user's string of nearby user tokens to the new list
        new_friends_in_radius = this_users_nearby_friends_tokens - this_users_nearby_friends_tokens_previous
        new_friends_in_radius.each do |friend_token|
          friend = User.find_by(token: friend_token)
          send_apn(user_token, friend.first_name, friend.last_name)
        end
        User.find_by(token: user_token).nearby_friends_tokens = this_users_nearby_friends_tokens.join(",")
      end

    # end
    render 'runs/info'
  end

  private
  def send_apn(recipient_token, first_name, last_name)
    APN = Houston::Client.development
    APN.certificate = "Bag Attributes
      friendlyName: Apple Development IOS Push Services: com.org.Isaac
      localKeyID: F6 71 9F C3 69 9E F7 28 37 D0 62 73 0A BA 71 24 63 0E 71 DF
  subject=/UID=com.org.Isaac/CN=Apple Development IOS Push Services: com.org.Isaac/OU=328SKT5YWC/C=US
  issuer=/C=US/O=Apple Inc./OU=Apple Worldwide Developer Relations/CN=Apple Worldwide Developer Relations Certification Authority
  -----BEGIN CERTIFICATE-----
  MIIFfjCCBGagAwIBAgIICORl7oRebFEwDQYJKoZIhvcNAQEFBQAwgZYxCzAJBgNV
  BAYTAlVTMRMwEQYDVQQKDApBcHBsZSBJbmMuMSwwKgYDVQQLDCNBcHBsZSBXb3Js
  ZHdpZGUgRGV2ZWxvcGVyIFJlbGF0aW9uczFEMEIGA1UEAww7QXBwbGUgV29ybGR3
  aWRlIERldmVsb3BlciBSZWxhdGlvbnMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkw
  HhcNMTUwNzE3MjAxNDQxWhcNMTYwNzE2MjAxNDQxWjB+MR0wGwYKCZImiZPyLGQB
  AQwNY29tLm9yZy5Jc2FhYzE7MDkGA1UEAwwyQXBwbGUgRGV2ZWxvcG1lbnQgSU9T
  IFB1c2ggU2VydmljZXM6IGNvbS5vcmcuSXNhYWMxEzARBgNVBAsMCjMyOFNLVDVZ
  V0MxCzAJBgNVBAYTAlVTMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
  mVhRtOxnb/D3qwZYJ27yjH3fnbbi/X3MPJ0tiq/82sTlsSkzOhuNFIJZcad5wkCY
  sPmzKdPK4DZ5WLcNdsfrysG1V23/tZjEZsJPh3bNKBHAWss3ut5mz83cu+kR3z65
  KK4A2EO6mGtCjlF1JOKiz2XdBrOUmG/SH86xFO9vaUsC2zFpesMpqQ4/g8a8IkL0
  99EsKmfqgSPl5jih33qQURPE18nhA7x7D7s6A4EmQP2qON9B+Mj3mkoilZXFZBYh
  FHLm6HkXTRDicRYuTVfY1/eew0dWXQMaMoLSx/eqbJqaukP6RT72MCqKot+rcfw+
  zYQhuSwZrvkKkYOEI3M78QIDAQABo4IB5TCCAeEwHQYDVR0OBBYEFPZxn8Npnvco
  N9Bicwq6cSRjDnHfMAkGA1UdEwQCMAAwHwYDVR0jBBgwFoAUiCcXCam2GGCL7Ou6
  9kdZxVJUo7cwggEPBgNVHSAEggEGMIIBAjCB/wYJKoZIhvdjZAUBMIHxMIHDBggr
  BgEFBQcCAjCBtgyBs1JlbGlhbmNlIG9uIHRoaXMgY2VydGlmaWNhdGUgYnkgYW55
  IHBhcnR5IGFzc3VtZXMgYWNjZXB0YW5jZSBvZiB0aGUgdGhlbiBhcHBsaWNhYmxl
  IHN0YW5kYXJkIHRlcm1zIGFuZCBjb25kaXRpb25zIG9mIHVzZSwgY2VydGlmaWNh
  dGUgcG9saWN5IGFuZCBjZXJ0aWZpY2F0aW9uIHByYWN0aWNlIHN0YXRlbWVudHMu
  MCkGCCsGAQUFBwIBFh1odHRwOi8vd3d3LmFwcGxlLmNvbS9hcHBsZWNhLzBNBgNV
  HR8ERjBEMEKgQKA+hjxodHRwOi8vZGV2ZWxvcGVyLmFwcGxlLmNvbS9jZXJ0aWZp
  Y2F0aW9uYXV0aG9yaXR5L3d3ZHJjYS5jcmwwCwYDVR0PBAQDAgeAMBMGA1UdJQQM
  MAoGCCsGAQUFBwMCMBAGCiqGSIb3Y2QGAwEEAgUAMA0GCSqGSIb3DQEBBQUAA4IB
  AQCce5cdJdKdpCG/pO5iyBKZi4jVy1vMl1MO5085JG2ufrXfudauQIIVntQBn/RT
  GULzCgNHrrA2U5PLjGLgi5pSVkmg7rWE6V706itenEFRJkhxXOZGkpqw7AML9AQZ
  YxpwyelSvLdbXIDbMTkQVzIWah27PtCCbGJm+2wccD1Gewn8a1BprxHVaoXoRYc4
  v+0Rs3CoF3sET2ull3NPG9FFyuVszuQI7RC6doVXL/Vs7Q7pbEFkJnjuTvaQGkAu
  C028kDYQ5dY4+vinvlVpcCZjgZwvB+yLuwh12Fku2+GSt2dCy7uE5k08MhTOFLjh
  YOx9ZvBsaI3LcKl58Pb95KWX
  -----END CERTIFICATE-----
  Bag Attributes
      friendlyName: Apple Development IOS Push Services: com.org.Isaac
      localKeyID: F6 71 9F C3 69 9E F7 28 37 D0 62 73 0A BA 71 24 63 0E 71 DF
  subject=/UID=com.org.Isaac/CN=Apple Development IOS Push Services: com.org.Isaac/OU=328SKT5YWC/C=US
  issuer=/C=US/O=Apple Inc./OU=Apple Worldwide Developer Relations/CN=Apple Worldwide Developer Relations Certification Authority
  -----BEGIN CERTIFICATE-----
  MIIFfjCCBGagAwIBAgIICORl7oRebFEwDQYJKoZIhvcNAQEFBQAwgZYxCzAJBgNV
  BAYTAlVTMRMwEQYDVQQKDApBcHBsZSBJbmMuMSwwKgYDVQQLDCNBcHBsZSBXb3Js
  ZHdpZGUgRGV2ZWxvcGVyIFJlbGF0aW9uczFEMEIGA1UEAww7QXBwbGUgV29ybGR3
  aWRlIERldmVsb3BlciBSZWxhdGlvbnMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkw
  HhcNMTUwNzE3MjAxNDQxWhcNMTYwNzE2MjAxNDQxWjB+MR0wGwYKCZImiZPyLGQB
  AQwNY29tLm9yZy5Jc2FhYzE7MDkGA1UEAwwyQXBwbGUgRGV2ZWxvcG1lbnQgSU9T
  IFB1c2ggU2VydmljZXM6IGNvbS5vcmcuSXNhYWMxEzARBgNVBAsMCjMyOFNLVDVZ
  V0MxCzAJBgNVBAYTAlVTMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
  mVhRtOxnb/D3qwZYJ27yjH3fnbbi/X3MPJ0tiq/82sTlsSkzOhuNFIJZcad5wkCY
  sPmzKdPK4DZ5WLcNdsfrysG1V23/tZjEZsJPh3bNKBHAWss3ut5mz83cu+kR3z65
  KK4A2EO6mGtCjlF1JOKiz2XdBrOUmG/SH86xFO9vaUsC2zFpesMpqQ4/g8a8IkL0
  99EsKmfqgSPl5jih33qQURPE18nhA7x7D7s6A4EmQP2qON9B+Mj3mkoilZXFZBYh
  FHLm6HkXTRDicRYuTVfY1/eew0dWXQMaMoLSx/eqbJqaukP6RT72MCqKot+rcfw+
  zYQhuSwZrvkKkYOEI3M78QIDAQABo4IB5TCCAeEwHQYDVR0OBBYEFPZxn8Npnvco
  N9Bicwq6cSRjDnHfMAkGA1UdEwQCMAAwHwYDVR0jBBgwFoAUiCcXCam2GGCL7Ou6
  9kdZxVJUo7cwggEPBgNVHSAEggEGMIIBAjCB/wYJKoZIhvdjZAUBMIHxMIHDBggr
  BgEFBQcCAjCBtgyBs1JlbGlhbmNlIG9uIHRoaXMgY2VydGlmaWNhdGUgYnkgYW55
  IHBhcnR5IGFzc3VtZXMgYWNjZXB0YW5jZSBvZiB0aGUgdGhlbiBhcHBsaWNhYmxl
  IHN0YW5kYXJkIHRlcm1zIGFuZCBjb25kaXRpb25zIG9mIHVzZSwgY2VydGlmaWNh
  dGUgcG9saWN5IGFuZCBjZXJ0aWZpY2F0aW9uIHByYWN0aWNlIHN0YXRlbWVudHMu
  MCkGCCsGAQUFBwIBFh1odHRwOi8vd3d3LmFwcGxlLmNvbS9hcHBsZWNhLzBNBgNV
  HR8ERjBEMEKgQKA+hjxodHRwOi8vZGV2ZWxvcGVyLmFwcGxlLmNvbS9jZXJ0aWZp
  Y2F0aW9uYXV0aG9yaXR5L3d3ZHJjYS5jcmwwCwYDVR0PBAQDAgeAMBMGA1UdJQQM
  MAoGCCsGAQUFBwMCMBAGCiqGSIb3Y2QGAwEEAgUAMA0GCSqGSIb3DQEBBQUAA4IB
  AQCce5cdJdKdpCG/pO5iyBKZi4jVy1vMl1MO5085JG2ufrXfudauQIIVntQBn/RT
  GULzCgNHrrA2U5PLjGLgi5pSVkmg7rWE6V706itenEFRJkhxXOZGkpqw7AML9AQZ
  YxpwyelSvLdbXIDbMTkQVzIWah27PtCCbGJm+2wccD1Gewn8a1BprxHVaoXoRYc4
  v+0Rs3CoF3sET2ull3NPG9FFyuVszuQI7RC6doVXL/Vs7Q7pbEFkJnjuTvaQGkAu
  C028kDYQ5dY4+vinvlVpcCZjgZwvB+yLuwh12Fku2+GSt2dCy7uE5k08MhTOFLjh
  YOx9ZvBsaI3LcKl58Pb95KWX
  -----END CERTIFICATE-----
  Bag Attributes
      friendlyName: isaac.moldofsky@gmail.com
      localKeyID: F6 71 9F C3 69 9E F7 28 37 D0 62 73 0A BA 71 24 63 0E 71 DF
  Key Attributes: <No Attributes>
  -----BEGIN RSA PRIVATE KEY-----
  MIIEowIBAAKCAQEAmVhRtOxnb/D3qwZYJ27yjH3fnbbi/X3MPJ0tiq/82sTlsSkz
  OhuNFIJZcad5wkCYsPmzKdPK4DZ5WLcNdsfrysG1V23/tZjEZsJPh3bNKBHAWss3
  ut5mz83cu+kR3z65KK4A2EO6mGtCjlF1JOKiz2XdBrOUmG/SH86xFO9vaUsC2zFp
  esMpqQ4/g8a8IkL099EsKmfqgSPl5jih33qQURPE18nhA7x7D7s6A4EmQP2qON9B
  +Mj3mkoilZXFZBYhFHLm6HkXTRDicRYuTVfY1/eew0dWXQMaMoLSx/eqbJqaukP6
  RT72MCqKot+rcfw+zYQhuSwZrvkKkYOEI3M78QIDAQABAoIBAHobI+Tnom42+WCM
  SsILzMQmr1vM9+9Wrr1Ng6g9/yDNTQHHhu0sZyj/qu2fqIsQGQZDr3ENHy1u8y27
  hdMh2xa3LQmTo90c6rfQ3rdF2JOhnwQtchExa7jpem1/aCXWsmY8OJv9QqaAMp1V
  K+zVM0PnHxtpAFhqIm4FjmjXSGYUg4Jb/zkhtkI7KRQsqKa4cxadl6wvTKF2JFxO
  ++0moduG7H5JhO/uKqR0qCUrPrM0dY5wt0jK64KfW7rcDW5OHxGUQKtYBsVxHxzp
  YyrOJaiGPpkMtXA2ldw8Xm/Lf7Uerk3r5HHKrtgpyPchkpWi7MvTcUwyAHEy1YVf
  go4ecskCgYEAx6KJuFpSuE91JpCZVPLiZi3q21mol3souo2OkTK9bP6JJ8RECzT4
  2oovJXV8ZCntt2A/L2vCRx0/KS58vGodE41xFgUcAqmaxGSY/pliGUv5Jz9wFx2W
  AaJBo09+u17Cm65WI7f9Gu/YeHXK38NqY0qsgdIUH75QRkF1oyXy9PMCgYEAxKP7
  DHjSjm4lLuQFQxBUX5UaXyuLQMVkIQDWw19sx8tU1sxxDKJztpBm0yKtw55P2CVY
  sEQef9Zv3pQGEaDIX5kuNbVlNqLun7iuM7b5riEBP2i08fioqxjzdXtE1Gd5xg+d
  9uaAwIWS4xuicHZp5RfDYP73p9NO39duljtV1IsCgYEAluP8klH62gJ8urRqoLGg
  e7jTHg5Lhot5QmACVS7zzDEre9o1z/6u5YeykO6XIaIrYgImX/Jj+ppZhgf0Eflm
  lsO+qPUdscl+CFk85psKcbJh1M93KpGbMwrv778DPB4om8EOrJrBfR2yEYJ+39h1
  Ti0/7DPcMA4J4MBTaQgi9g8CgYAIdtqGlejSUrFtDEmhsmE/YAarlA9BcX224fdc
  n43qJ7l2KYSwO4npkNusOPDr27OqJSllJPl/HTbhiNOeDKKzYr+XdkBuEqNc4rE0
  7qpesXMBTLuFMuPnwYIxS2YSEoYuXVu6Vf+yyc0h032xg5dZUiWJ1k/IvJLHldlf
  xBwUswKBgGkDxcUilOurZovlBjRcHE7QgiCB+G1TI09xiGiTcoNgytmN4Z3rLI37
  MlM78t/YtdVwLIxfYm2cGHtnc7nxIvyNWaYS3FuyI7+2hy2FoHrD2KGXNdFQhsrG
  xkNyeGrMGzxRuVPN2tyMNzZIJTRBqBc3swNrXdjRw5qvpR6nUuVM
  -----END RSA PRIVATE KEY-----
  Bag Attributes
      friendlyName: isaac.moldofsky@gmail.com
      localKeyID: F6 71 9F C3 69 9E F7 28 37 D0 62 73 0A BA 71 24 63 0E 71 DF
  Key Attributes: <No Attributes>
  -----BEGIN RSA PRIVATE KEY-----
  MIIEowIBAAKCAQEAmVhRtOxnb/D3qwZYJ27yjH3fnbbi/X3MPJ0tiq/82sTlsSkz
  OhuNFIJZcad5wkCYsPmzKdPK4DZ5WLcNdsfrysG1V23/tZjEZsJPh3bNKBHAWss3
  ut5mz83cu+kR3z65KK4A2EO6mGtCjlF1JOKiz2XdBrOUmG/SH86xFO9vaUsC2zFp
  esMpqQ4/g8a8IkL099EsKmfqgSPl5jih33qQURPE18nhA7x7D7s6A4EmQP2qON9B
  +Mj3mkoilZXFZBYhFHLm6HkXTRDicRYuTVfY1/eew0dWXQMaMoLSx/eqbJqaukP6
  RT72MCqKot+rcfw+zYQhuSwZrvkKkYOEI3M78QIDAQABAoIBAHobI+Tnom42+WCM
  SsILzMQmr1vM9+9Wrr1Ng6g9/yDNTQHHhu0sZyj/qu2fqIsQGQZDr3ENHy1u8y27
  hdMh2xa3LQmTo90c6rfQ3rdF2JOhnwQtchExa7jpem1/aCXWsmY8OJv9QqaAMp1V
  K+zVM0PnHxtpAFhqIm4FjmjXSGYUg4Jb/zkhtkI7KRQsqKa4cxadl6wvTKF2JFxO
  ++0moduG7H5JhO/uKqR0qCUrPrM0dY5wt0jK64KfW7rcDW5OHxGUQKtYBsVxHxzp
  YyrOJaiGPpkMtXA2ldw8Xm/Lf7Uerk3r5HHKrtgpyPchkpWi7MvTcUwyAHEy1YVf
  go4ecskCgYEAx6KJuFpSuE91JpCZVPLiZi3q21mol3souo2OkTK9bP6JJ8RECzT4
  2oovJXV8ZCntt2A/L2vCRx0/KS58vGodE41xFgUcAqmaxGSY/pliGUv5Jz9wFx2W
  AaJBo09+u17Cm65WI7f9Gu/YeHXK38NqY0qsgdIUH75QRkF1oyXy9PMCgYEAxKP7
  DHjSjm4lLuQFQxBUX5UaXyuLQMVkIQDWw19sx8tU1sxxDKJztpBm0yKtw55P2CVY
  sEQef9Zv3pQGEaDIX5kuNbVlNqLun7iuM7b5riEBP2i08fioqxjzdXtE1Gd5xg+d
  9uaAwIWS4xuicHZp5RfDYP73p9NO39duljtV1IsCgYEAluP8klH62gJ8urRqoLGg
  e7jTHg5Lhot5QmACVS7zzDEre9o1z/6u5YeykO6XIaIrYgImX/Jj+ppZhgf0Eflm
  lsO+qPUdscl+CFk85psKcbJh1M93KpGbMwrv778DPB4om8EOrJrBfR2yEYJ+39h1
  Ti0/7DPcMA4J4MBTaQgi9g8CgYAIdtqGlejSUrFtDEmhsmE/YAarlA9BcX224fdc
  n43qJ7l2KYSwO4npkNusOPDr27OqJSllJPl/HTbhiNOeDKKzYr+XdkBuEqNc4rE0
  7qpesXMBTLuFMuPnwYIxS2YSEoYuXVu6Vf+yyc0h032xg5dZUiWJ1k/IvJLHldlf
  xBwUswKBgGkDxcUilOurZovlBjRcHE7QgiCB+G1TI09xiGiTcoNgytmN4Z3rLI37
  MlM78t/YtdVwLIxfYm2cGHtnc7nxIvyNWaYS3FuyI7+2hy2FoHrD2KGXNdFQhsrG
  xkNyeGrMGzxRuVPN2tyMNzZIJTRBqBc3swNrXdjRw5qvpR6nUuVM
  -----END RSA PRIVATE KEY-----
  "
    notification = Houston::Notification.new(device: recipient_token)
    notification.alert = "#{first_name} #{last_name} is now within 1000 feet of you!"
    notification.badge = 17
    notification.sound = "sosumi.aiff"
    notification.category = "INVITE_CATEGORY"
    notification.content_available = true
    notification.custom_data = {foo: "bar"}
    APN.push(notification)
  end
end
