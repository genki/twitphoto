require 'uri'

module TwitPhoto
class Adaptors
  class InstagramAdaptor
    def self.domains
      %w(http://instagr.am)
    end

    def self.getImageUrl url
      domain = self.domains.select { |d| url.to_s.start_with?(d) }
      return nil if domain.empty?

      # ensure last char is '/'
      if url[url.length - 1] != "/"[0]
        url = url + "/"
      end

      return url + "media/?size=l"
    end
  end

  class LockerzAdaptor

    # TweetPhoto was a good name, why they changed twice I don't understand
    def self.domains
      %w(http://tweetphoto.com http://plixi.com http://lockerz.com)
    end

    def self.getImageUrl url
      domain = self.domains.select { |d| url.to_s.start_with?(d) }
      return nil if domain.empty?

      return "http://api.plixi.com/api/tpapi.svc/imagefromurl?size=large&url=" + url
    end
  end

  class TwitPicAdaptor
    def self.domains
      %w(http://twitpic.com)
    end

    def self.getImageUrl url
      domain = self.domains.select { |d| url.to_s.start_with?(d) }
      return nil if domain.empty?

      uri = URI.parse(url)
      id = uri.path

      return "http://twitpic.com/show/large" + id
    end
  end

  class YFrogAdaptor
    # check for "http://yfrog." (no domain since yfrog supports many domains)
    def self.domains
      %w(http://yfrog.)
    end

    def self.getImageUrl url
        domain = self.domains.select { |d| url.to_s.start_with?(d) }
        return nil if domain.empty?

        uri = URI.parse(url)
        id = uri.path

        return "http://yfrog.com" + id + ":medium"
    end
  end

  class TwitGooAdaptor
    def self.domains
      %w(http://twitgoo.com)
    end

    def self.getImageUrl url
      domain = self.domains.select { |d| url.to_s.start_with?(d) }
      return nil if domain.empty?

      # ensure last char is '/'
      if url[url.length - 1] != "/"[0]
        url = url + "/"
      end

      return url + "img"
    end
  end

  class ImglyAdaptor
    # check for "http://yfrog." (no domain since yfrog supports many domains)
    def self.domains
      %w(http://img.ly)
    end

    def self.getImageUrl url
        domain = self.domains.select { |d| url.to_s.start_with?(d) }
        return nil if domain.empty?

        uri = URI.parse(url)
        id = uri.path.split('/').last

        # Must end with /
        return "http://img.ly/show/full/" + id + "/"
    end
  end

end
end
