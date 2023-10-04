%Doctor.Config{
  exception_moduledoc_required: true,
  failed: false,
  ignore_modules: [],
  ignore_paths: [
    "lib/yggdrasil/repo.ex",
    "lib/yggdrasil_web.ex",
    "lib/yggdrasil_web/controllers/error_html.ex",
    "lib/yggdrasil_web/controllers/error_json.ex",
    "lib/yggdrasil_web/controllers/page_controller.ex",
    "lib/yggdrasil_web/controllers/page_html.ex",
    "lib/yggdrasil_web/endpoint.ex",
    "lib/yggdrasil_web/router.ex",
    "lib/yggdrasil_web/telemetry.ex",
    "lib/yggdrasil_web/views/page_view.ex"
  ],
  min_module_doc_coverage: 40,
  min_module_spec_coverage: 0,
  min_overall_doc_coverage: 50,
  min_overall_spec_coverage: 9.5,
  min_overall_moduledoc_coverage: 50,
  raise: false,
  reporter: Doctor.Reporters.Full,
  struct_type_spec_required: true,
  umbrella: false
}
