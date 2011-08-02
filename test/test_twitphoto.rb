require 'helper'
require 'test/unit'
require 'twitphoto'
require 'adaptors'
require 'twitter'

class TestTwitphoto < Test::Unit::TestCase

  should "test usage with Twitter gem" do

    tweetWithTwitterMedia = Twitter.status(82472660038197249, :include_entities => 't')
    results = TwitPhoto::TwitPhoto.getPhotoUrlsFromTweet(tweetWithTwitterMedia)
    assert_equal 1, results.length
    assert_equal "http://p.twimg.com/ASUAcoWCIAIsmIA.png", results[0]

    RTtweetWithTwitterMedia = Twitter.status(82486891202621440, :include_entities => 't')
    results = TwitPhoto::TwitPhoto.getPhotoUrlsFromTweet(RTtweetWithTwitterMedia)
    assert_equal 1, results.length
    assert_equal "http://p.twimg.com/ASUAcoWCIAIsmIA.png", results[0]

    tweetWithThirdPartyMedia = Twitter.status(82480106379026433, :include_entities => 't')
    results = TwitPhoto::TwitPhoto.getPhotoUrlsFromTweet tweetWithThirdPartyMedia
    assert_equal 1, results.length
    assert_equal "http://yfrog.com/kea33tj:medium", results[0]

    tweetWithThirdPartyMediaMulti = Twitter.status(82513016645623808, :include_entities => 't')
    results = TwitPhoto::TwitPhoto.getPhotoUrlsFromTweet tweetWithThirdPartyMediaMulti
    assert_equal 3, results.length

    tweetWithNoMedia = Twitter.status(82153561638699008, :include_entities => 't')
    results = TwitPhoto::TwitPhoto.getPhotoUrlsFromTweet tweetWithNoMedia
    assert_equal 0, results.length
  end

  should "test getPhotoFromUrl" do
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlFromUrl("http://tweetphoto.com/28103398"), "http://api.plixi.com/api/tpapi.svc/imagefromurl?size=large&url=http://tweetphoto.com/28103398"
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlFromUrl("http://lockerz.com/s/110826629"), "http://api.plixi.com/api/tpapi.svc/imagefromurl?size=large&url=http://lockerz.com/s/110826629"
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlFromUrl("http://plixi.com/p/89511189"), "http://api.plixi.com/api/tpapi.svc/imagefromurl?size=large&url=http://plixi.com/p/89511189"
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlFromUrl("http://yfrog.com/gzozrllj"), "http://yfrog.com/gzozrllj:medium"
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlFromUrl("http://instagr.am/p/Fv3t0"), "http://instagr.am/p/Fv3t0/media/?size=l"
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlFromUrl("http://twitpic.com/5bpgp0"), "http://twitpic.com/show/large/5bpgp0"
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlFromUrl("http://twitgoo.com/2l2uq0"), "http://twitgoo.com/2l2uq0/img"
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlFromUrl("http://img.ly/6IWZ"), "http://img.ly/show/full/6IWZ/"
    assert TwitPhoto::TwitPhoto.getPhotoUrlFromUrl("http://google.ca").nil?
  end

  should "test getPhotoUrlsFromText" do
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlsFromText("http:www.google.com").length, 0
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlsFromText("http:www.google.com http://tweetphoto.com/28103398").length, 1
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlsFromText("http:www.google.com http://tweetphoto.com/28103398 http://instagr.am/p/Fv3t0").length, 2
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlsFromText("http://lockerz.com/s/110826629").length, 1
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlsFromText("Content http://twitpic.com/5bpgp0 content").length, 1
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlsFromText("TwitGoo AND Imgly http://twitgoo.com/2l2uq0 yay http://img.ly/6IWZ").length, 2
    assert_equal TwitPhoto::TwitPhoto.getPhotoUrlsFromText("Content http://yfrog.com/gzozrllj http://plixi.com/p/89511189 content").length, 2
  end

  should "test TweetPhot/Lockerz/Plixi" do
    assert_equal TwitPhoto::Adaptors::LockerzAdaptor.getImageUrl("http://tweetphoto.com/28103398"), "http://api.plixi.com/api/tpapi.svc/imagefromurl?size=large&url=http://tweetphoto.com/28103398"
    assert_equal TwitPhoto::Adaptors::LockerzAdaptor.getImageUrl("http://lockerz.com/s/110826629"), "http://api.plixi.com/api/tpapi.svc/imagefromurl?size=large&url=http://lockerz.com/s/110826629"
    assert_equal TwitPhoto::Adaptors::LockerzAdaptor.getImageUrl("http://plixi.com/p/89511189"), "http://api.plixi.com/api/tpapi.svc/imagefromurl?size=large&url=http://plixi.com/p/89511189"
    assert TwitPhoto::Adaptors::YFrogAdaptor.getImageUrl("http://notyfrog.com/gzozrllj").nil?
  end

  should "test Yfrog" do
    assert_equal TwitPhoto::Adaptors::YFrogAdaptor.getImageUrl("http://yfrog.com/gzozrllj"), "http://yfrog.com/gzozrllj:medium"
    assert TwitPhoto::Adaptors::YFrogAdaptor.getImageUrl("http://notyfrog.com/gzozrllj").nil?
    assert_equal TwitPhoto::Adaptors::YFrogAdaptor.getImageUrl("http://yfrog.com/gz23uqdj"), "http://yfrog.com/gz23uqdj:medium"
  end

  should "test Instagram" do
    assert_equal TwitPhoto::Adaptors::InstagramAdaptor.getImageUrl("http://instagr.am/p/Fv3t0"), "http://instagr.am/p/Fv3t0/media/?size=l"
    assert TwitPhoto::Adaptors::InstagramAdaptor.getImageUrl("http://instagr.aam/p/Fv3t0").nil?
    assert_equal TwitPhoto::Adaptors::InstagramAdaptor.getImageUrl("http://instagr.am/p/Fv3t0/"), "http://instagr.am/p/Fv3t0/media/?size=l"
  end

  should "test TwitPic" do
    assert_equal TwitPhoto::Adaptors::TwitPicAdaptor.getImageUrl("http://twitpic.com/5bpgp0"), "http://twitpic.com/show/large/5bpgp0"
    assert TwitPhoto::Adaptors::TwitPicAdaptor.getImageUrl("http://nottwitpic.com/5bpgp0").nil?
    assert_equal TwitPhoto::Adaptors::TwitPicAdaptor.getImageUrl("http://twitpic.com/5b3rhe"), "http://twitpic.com/show/large/5b3rhe"
  end

  should "test TwitGoo" do
    assert_equal TwitPhoto::Adaptors::TwitGooAdaptor.getImageUrl("http://twitgoo.com/2l2uq0"), "http://twitgoo.com/2l2uq0/img"
    assert TwitPhoto::Adaptors::TwitGooAdaptor.getImageUrl("http://nottwitgoo.com/2l2uq0").nil?
    assert_equal TwitPhoto::Adaptors::TwitGooAdaptor.getImageUrl("http://twitgoo.com/2l2uq0/"), "http://twitgoo.com/2l2uq0/img"
  end

  should "test Imgly" do
    assert_equal TwitPhoto::Adaptors::ImglyAdaptor.getImageUrl("http://img.ly/6IWZ"), "http://img.ly/show/full/6IWZ/"
    assert TwitPhoto::Adaptors::ImglyAdaptor.getImageUrl("http://imgxlily.com/2l2uq0").nil?
    assert_equal TwitPhoto::Adaptors::ImglyAdaptor.getImageUrl("http://img.ly/6IWZ/"), "http://img.ly/show/full/6IWZ/"
  end


end
