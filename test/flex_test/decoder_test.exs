defmodule FlexTest.Decoder do
  use ExUnit.Case
  doctest Flex

  alias Flex.Decoder

  @tag disabled: false
  test "decoder decodes" do
    assert %{"type" => "Int", "value" => "1"}
           |> Decoder.decode() == 1
  end

  test "Void" do
    assert %{
             "type" => "Void"
           }
           |> Decoder.decode() == nil
  end

  test "Optional nil" do
    assert %{
             "type" => "Optional",
             "value" => nil
           }
           |> Decoder.decode() == nil
  end

  test "Optional non-nil" do
    assert %{
             "type" => "Optional",
             "value" => %{
               "type" => "Int8",
               "value" => "123"
             }
           }
           |> Decoder.decode() == 123
  end

  test "Bool true" do
    assert %{
             "type" => "Bool",
             "value" => true
           }
           |> Decoder.decode() == true
  end

  test "boolean false" do
    assert %{
             "type" => "Bool",
             "value" => false
           }
           |> Decoder.decode() == false
  end

  test "String empty" do
    assert %{
             "type" => "String",
             "value" => ""
           }
           |> Decoder.decode() == ""
  end

  test "String non-empty" do
    assert %{
             "type" => "String",
             "value" => "snargle-blob"
           }
           |> Decoder.decode() == "snargle-blob"
  end

  test "Address" do
    assert %{
             "type" => "Address",
             "value" => "0x1234"
           }
           |> Decoder.decode() == "0x1234"
  end

  test "[U]Int, [U]Int8, [U]Int16, [U]Int32,[U]Int64,[U]Int128, [U]Int256,  Word8, Word16, Word32, or Word64" do
    assert %{
             "type" => "Int",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "UInt",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Int8",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "UInt8",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Int16",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "UInt16",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Int32",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "UInt32",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Int64",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "UInt64",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Int128",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "UInt128",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Int256",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "UInt256",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Word8",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Word16",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Word32",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Word64",
             "value" => "1"
           }
           |> Decoder.decode() == 1
  end

  test "[U]Fix64" do
    assert %{
             "type" => "Fix64",
             "value" => "1312.41212"
           }
           |> Decoder.decode() == 1312.41212

    assert %{
             "type" => "UFix64",
             "value" => "-1312.4121299999999"
           }
           |> Decoder.decode() == -1312.4121299999999
  end

  test "Array int type" do
    input = %{
      "type" => "Array",
      "value" => [
        %{
          "type" => "Int",
          "value" => "123"
        },
        %{
          "type" => "Int",
          "value" => "5123"
        },
        %{
          "type" => "Int",
          "value" => "999"
        }
      ]
    }

    assert input |> Decoder.decode() == [123, 5123, 999]
  end

  test "Array string type" do
    input = %{
      "type" => "Array",
      "value" => [
        %{
          "type" => "String",
          "value" => "test1"
        },
        %{
          "type" => "String",
          "value" => "test2"
        },
        %{
          "type" => "String",
          "value" => "test3"
        }
      ]
    }

    assert input |> Decoder.decode() == ["test1", "test2", "test3"]
  end

  test "Dictionary" do
    input1 = %{
      "type" => "Dictionary",
      "value" => [
        %{
          "key" => %{
            "type" => "UInt8",
            "value" => "128"
          },
          "value" => %{
            "type" => "String",
            "value" => "test"
          }
        }
      ]
    }

    assert input1 |> Decoder.decode() == %{128 => "test"}

    # Check the nested scenario
    input2 = %{
      "type" => "Dictionary",
      "value" => [
        %{
          "key" => %{
            "type" => "String",
            "value" => "Wuuzahh"
          },
          "value" => input1
        }
      ]
    }

    assert input2 |> Decoder.decode() == %{"Wuuzahh" => %{128 => "test"}}
  end

  test "Composites (Struct, Resource, Event, Contract, Enum)" do
    resource_input = %{
      "type" => "Resource",
      "value" => %{
        "id" => "0x3.GreatContract.GreatNFT",
        "fields" => [
          %{
            "name" => "power",
            "value" => %{"type" => "Int", "value" => "1"}
          },
          %{
            "name" => "gear",
            "value" => %{"type" => "String", "value" => "Fourth"}
          }
        ]
      }
    }

    assert resource_input |> Decoder.decode() ==
             {
               :resource,
               "0x3.GreatContract.GreatNFT",
               %{
                 "power" => 1,
                 "gear" => "Fourth"
               }
             }
  end

  test "Path" do
    input = %{
      "type" => "Path",
      "value" => %{
        # "storage" | "private" | "public",
        "domain" => "storage",
        "identifier" => "flowTokenVault"
      }
    }

    assert input |> Decoder.decode() == {:path, "storage", "flowTokenVault"}
  end

  test "Type" do
    input = %{
      "type" => "Type",
      "value" => %{
        "staticType" => "Int"
      }
    }

    assert input |> Decoder.decode() == {:type, "Int"}
  end

  test "Capability" do
    input = %{
      "type" => "Capability",
      "value" => %{
        "path" => "/public/someInteger",
        "address" => "0x1",
        "borrowType" => "Int"
      }
    }

    assert input |> Decoder.decode() ==
             {:capability,
              %{
                path: "/public/someInteger",
                address: "0x1",
                borrow_type: "Int"
              }}
  end
end
