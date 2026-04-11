return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      -- extensions
      "Davidyz/VectorCode",
      "ravitemer/codecompanion-history.nvim"
    },
    opts = {
      strategies = {
        chat = {
          adapter = "opencode"
        },
        inline = {
          adapter = "gemuning"
        },
        cmd = {
          adapter = "gemuning"
        }
      },
      interactions = {
        cli = {
          agent = "claude_code",
          agents = {
            claude_code = {
              cmd = "claude",
              args = {},
              description = "Claude Code CLI",
              provider = "terminal",
            },
          },
        },
      },
      adapters = {
        http = {
          locallama = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "locallama", -- Give this adapter a different name to differentiate it from the default ollama adapter
              opts = {
                vision = false,
                stream = true,
              },
              schema = {
                model = {
                  default = "qwen2.5-coder:3b",
                },
                num_ctx = {
                  default = 20000,
                },
                think = {
                  default = false,
                },
                keep_alive = {
                  default = "5m",
                },
              },
            })
          end,
          gemuning = function()
            return require("codecompanion.adapters").extend("gemini", {
              name = "gemuning",
              opts = {
                vision = false,
                stream = true,
              },
              schema = {
                model = {
                  default = "gemini-2.0-flash"
                },
                think = {
                  default = false,
                },
              }
            })
          end
        },
        acp = {
          gemuning_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              defaults = {
                auth_method = "gemini-api-key", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
              },
              env = {
                GEMINI_API_KEY = "GEMINI_API_KEY",
              },
              schema = {
                model = {
                  default = "gemini-2.0-flash"
                },
                think = {
                  default = false,
                },
              }
            })
          end,
          gemuning_reloaded_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              defaults = {
                auth_method = "gemini-api-key", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
              },
              env = {
                GEMINI_API_KEY = "GEMINI_API_KEY",
              },
              schema = {
                model = {
                  default = "gemini-2.5-flash"
                },
                think = {
                  default = false,
                },
              }
            })
          end,
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_tools = true, -- Required for individual tools
            -- ... other options
          }
        },
        vectorcode = {
          enabled = true
        },
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "mm",
            -- Keymap to save the current chat manually (when auto_save is disabled)
            save_chat_keymap = "ms",
            -- Save all chats by default (disable to save only manually using 'sc')
            auto_save = true,
            -- Number of days after which chats are automatically deleted (0 to disable)
            expiration_days = 3,
            -- Picker interface (auto resolved to a valid picker)
            picker = "fzf-lua", --- ("telescope", "snacks", "fzf-lua", or "default")
            ---Optional filter function to control which chats are shown when browsing
            chat_filter = nil,  -- function(chat_data) return boolean end
            -- Customize picker keymaps (optional)
            picker_keymaps = {
              rename = { n = "r", i = "<M-r>" },
              delete = { n = "d", i = "<M-d>" },
              duplicate = { n = "<C-y>", i = "<C-y>" },
            },
            ---Automatically generate titles for new chats
            auto_generate_title = true,
            title_generation_opts = {
              ---Adapter for generating titles (defaults to current chat adapter)
              adapter = "gemini",          -- "copilot"
              ---Model for generating titles (defaults to current chat model)
              model = "gemini-2.5-flash",  -- "gpt-4o"
              ---Number of user prompts after which to refresh the title (0 to disable)
              refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
              ---Maximum number of times to refresh the title (default: 3)
              max_refreshes = 3,
              format_title = function(original_title)
                -- this can be a custom function that applies some custom
                -- formatting to the title.
                --local timestamp = vim.fn.localtime()
                --local date_string = vim.fn.strftime("%Y-%m-%d %H:%M:%S", timestamp)
                return original_title
              end
            },
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            ---Enable detailed logging for history extension
            enable_logging = false,

            -- Summary system
            summary = {
              -- Keymap to generate summary for current chat (default: "gcs")
              create_summary_keymap = "gcs",
              -- Keymap to browse summaries (default: "gbs")
              browse_summaries_keymap = "gbs",

              generation_opts = {
                adapter = "gemini",          -- defaults to current chat adapter
                model = "gemini-2.5-flash",  -- defaults to current chat model
                context_size = 90001,        -- max tokens that the model supports
                include_references = true,   -- include slash command content
                include_tool_outputs = true, -- include tool execution results
                system_prompt = nil,         -- custom system prompt (string or function)
                format_summary = nil,        -- custom function to format generated summary e.g to remove <think/> tags from summary
              },
            },

            -- Memory system (requires VectorCode CLI)
            memory = {
              -- Automatically index summaries when they are generated
              auto_create_memories_on_summary_generation = true,
              -- Path to the VectorCode executable
              vectorcode_exe = "vectorcode",
              -- Tool configuration
              tool_opts = {
                -- Default number of memories to retrieve
                default_num = 10
              },
              -- Enable notifications for indexing progress
              notify = true,
              -- Index all existing memories on startup
              -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
              index_on_startup = false,
            },
          }
        }
      }
    },
  },
  {
    "Davidyz/VectorCode",
    dependencies = { "nvim-lua/plenary.nvim" },
    version = "*",
    build = "uv tool upgrade vectorcode",
    cmd = "VectorCode", -- if you're lazy-loading VectorCode
  },
  {
    'milanglacier/minuet-ai.nvim',
    config = function()
      require('minuet').setup {
        provider = 'gemini',
        provider_options = {
          gemini = {
            optional = {
              generationConfig = {
                maxOutputTokens = 256,
                -- When using `gemini-2.5-flash`, it is recommended to entirely
                -- disable thinking for faster completion retrieval.
                thinkingConfig = {
                  thinkingBudget = 0,
                },
              },
              safetySettings = {
                {
                  -- HARM_CATEGORY_HATE_SPEECH,
                  -- HARM_CATEGORY_HARASSMENT
                  -- HARM_CATEGORY_SEXUALLY_EXPLICIT
                  category = 'HARM_CATEGORY_DANGEROUS_CONTENT',
                  -- BLOCK_NONE
                  threshold = 'BLOCK_ONLY_HIGH',
                },
              },
            },
          },
        }
      }
    end,
  },
}
