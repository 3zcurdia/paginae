# frozen_string_literal: true

require "test_helper"

module Paginae
  class TestWeb < Minitest::Test
    class MockProductPage
      include Paginae::Web

      attribute :name, css: ".productView-title"
      attribute :model, css: ".productView-info-value"
      attribute :overview, id: "productAboutWrapper"
      attribute :manuals, css: "#productManuals a", mapped: :map_manuals

      private

      def map_manuals(node)
        [node.text&.gsub(/\s+/, " ")&.strip, node["href"]]
      end
    end

    def page
      @page ||= MockProductPage.new(File.read(File.expand_path("../fixtures/product_page.html", __dir__)))
    end

    def manuals
      {
        "Quick Specs" => "https://products.geappliances.com/MarketingObjectRetrieval/Dispatcher?RequestType=PDF&Name=PSE25KYHFS_21.pdf",
        "Installation Instructions" => "https://products.geappliances.com/MarketingObjectRetrieval/Dispatcher?RequestType=PDF&Name=49-1000471-2.pdf",
        "Use and Care Manual" => "https://products.geappliances.com/MarketingObjectRetrieval/Dispatcher?RequestType=PDF&Name=49-1000471-2.pdf",
        "Energy Guide" => "https://products.geappliances.com/MarketingObjectRetrieval/Dispatcher?RequestType=PDF&Name=294D1325P002_USA.pdf"
      }
    end

    # rubocop:disable Layout/LineLength
    def overview
      "Fingerprint Resistant Stainless Easily wipe away smudges and fingerprints for a look that's always sparkling clean Showcase LED Lighting Easily find even the smallest food items thanks to 7 flush-mounted LED lights, which shed more crisp, even light throughout the interior without wasting space Play Video Turbo Cool setting Quickly bring down the interior refrigerator temperature thanks to an innovative Turbo Cool setting, which circulates an extra boost of cold air throughout the interior when selected Play Video Quick Ice setting This refrigerator's icemaker features a cutting-edge Quick Ice setting which creates ice up to 50% faster than normal settings Play Video QuickSpace Shelf Find the perfect place for everything in your refrigerator - even tall items - thanks to a space saving shelf system which easily slides back to create more room Interior Storage Drawers Three refrigerator pull out drawers with clear fronts provide the perfect, sealed environment to keep your produce organized Adjustable Glass Shelves Contain spills and make cleanup quick and easy, thanks to spill proof glass shelving with raised edges Arctica Icemaker Fresh, filtered ice is within reach thanks to a cutting-edge Arctica icemaker and innovative easy access door External Dispenser Get advanced filtered water and ice from a specially engineered, seamless dispenser located on the outside of the door Electronic Display Always get the refrigerator temperature just right with a sleek electronic display that allows for precise settings Advanced Water Filtration Reduces impurities, lead and trace pharmaceuticals from water and ice* (* Removes 98% of ibuprofen, atenolol, fluoxetine, progesterone and trimethoprim. Impurities are not necessarily in all users water) Glass Freezer Shelves Easily store even the smallest or thinnest items in the freezer section thanks for durable glass shelving Freezer Baskets Three organizational freezer baskets provide plenty of easy-access storage for frozen foods Adaptive Defrost With FrostGuard technology, your freezer will only defrost when needed, as opposed to a time cycle, leading to less freezer burn and more energy savings Enhanced Shabbos Mode The Shabbos Keeper connects to your refrigerator to automatically enable Shabbos compatible modes each week and before every holiday (Shabbos Keeper sold separately, visit www.zmantechnologies.com for details) See all features"
    end
    # rubocop:enable Layout/LineLength

    def test_complete_product_page
      assert_equal "GE Profile Series ENERGY STAR 25.3 Cu. Ft. Side-by-Side Refrigerator", page.name
      assert_equal "PSE25KYHFS", page.model
      assert_equal overview, page.overview
      assert_equal manuals, page.manuals
    end
  end
end
