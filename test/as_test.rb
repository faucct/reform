require 'test_helper'

class AsTest < BaseTest
  class AlbumForm < Reform::Form
    property :name, :as => :title

    property :single, :as => :hit do
      property :title
    end

    collection :tracks, :as => :songs do
      property :name, :as => :title
    end

    property :band do
      property :company, :as => :label do
        property :business, :as => :name
      end
    end
  end

  let (:song2) { Song.new("Roxanne") }

  subject { AlbumForm.new(Album.new("Best Of", hit, [Song.new("Fallout"), song2])) }

  it { subject.name.must_equal "Best Of" }
  it { subject.single.title.must_equal "Roxanne" }
  it { subject.tracks[0].name.must_equal "Fallout" }
  it { subject.tracks[1].name.must_equal "Roxanne" }


  describe "#validate" do
    let (:params) {
      {
        "name" => "Best Of The Police",
        "single"   => {"title" => "So Lonely"},
        "tracks" => [{"name" => "Message In A Bottle"}, {"name" => "Roxanne"}]
      }
    }

    before { subject.validate(params) }

    it { subject.name.must_equal "Best Of The Police" }
    it { subject.single.title.must_equal "So Lonely" }
    it { subject.tracks[0].name.must_equal "Message In A Bottle" }
    it { subject.tracks[1].name.must_equal "Roxanne" }
  end


  describe "#sync" do
    before {
      subject.tracks[1].name = "Livin' Ain't No Crime"
      subject.sync
    }

    it { song2.title.must_equal "Livin' Ain't No Crime" }
  end

  describe "#save (nested hash)" do

  end
end