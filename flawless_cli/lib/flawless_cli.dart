/// Command-line tooling for Flawless.
///
/// This library exposes the public API used by the CLI package and by any
/// integrations that want to reuse its configuration and versioning helpers.
library;

export 'src/utils/config.dart'
    show
        FlawlessCliConfig,
        loadCliConfig,
        saveCliConfig,
        resolveDashboardBaseUrl,
        flawlessDefaultDashboardUrl;
export 'src/version/suite_version.dart' show flawlessSuiteVersion;
