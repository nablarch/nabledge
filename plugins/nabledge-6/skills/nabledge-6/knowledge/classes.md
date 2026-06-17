# Class Index

## component

### Domaアダプタ
path: component/adapters/adapters-doma-adaptor.json
- Transactional
- DomaDaoRepository
- DomaConfig
- DomaTransactionStepListener
- DomaTransactionItemWriteListener
- DomaTransactionNotSupportedConfig
- ConnectionFactoryFromDomaConnection
- NablarchJdbcLogger
- DomaStatementProperties

### Jakarta RESTful Web Servicesアダプタ
path: component/adapters/adapters-jaxrs-adaptor.json
- JaxRsMethodBinderFactory
- JerseyJaxRsHandlerListFactory
- Jackson2BodyConverter
- JaxbBodyConverter
- FormUrlEncodedConverter
- MultipartFormDataBodyConverter
- ResteasyJaxRsHandlerListFactory
- JaxRsHandlerListFactory

### JSR310(Date and Time API)アダプタ
path: component/adapters/adapters-jsr310-adaptor.json
- DateTimeConfiguration
- BasicDateTimeConfiguration

### E-mail FreeMarkerアダプタ
path: component/adapters/adapters-mail-sender-freemarker-adaptor.json
- FreeMarkerMailProcessor
- MailRequester
- ComponentFactory
- TemplateEngineProcessedResult

### E-mail Thymeleafアダプタ
path: component/adapters/adapters-mail-sender-thymeleaf-adaptor.json
- ThymeleafMailProcessor
- MailRequester
- TemplateEngineProcessedResult

### E-mail Velocityアダプタ
path: component/adapters/adapters-mail-sender-velocity-adaptor.json
- VelocityMailProcessor
- MailRequester
- ComponentFactory
- TemplateEngineProcessedResult

### Micrometerアダプタ
path: component/adapters/adapters-micrometer-adaptor.json
- ComponentFactory
- LoggingMeterRegistryFactory
- DefaultMeterBinderListProvider
- BasicApplicationDisposer
- SimpleMeterRegistryFactory
- CloudWatchMeterRegistryFactory
- DatadogMeterRegistryFactory
- StatsdMeterRegistryFactory
- OtlpMeterRegistryFactory
- prefix
- xmlConfigPath
- NablarchGcCountMetrics
- tags
- CloudWatchAsyncClientProvider
- cloudWatchAsyncClientProvider
- GlobalMeterRegistryFactory
- TimerMetricsHandler
- HandlerMetricsMetaDataBuilder
- HttpRequestTimeMetricsMetaDataBuilder
- BatchTransactionTimeMetricsLogger
- setMetricsName(String)
- CompositeCommitLogger
- BasicCommitLogger
- CommitLogger
- BatchProcessedRecordCountMetricsLogger
- LogCountMetrics
- MetricsMetaData
- コンストラクタ
- LoggerManager
- LogPublisher
- LogLevel
- SqlTimeMetricsDaoContext
- SqlTimeMetricsDaoContextFactory
- DaoContext
- JmxGaugeMetrics
- MBeanAttributeCondition
- Initializable

### Redisヘルスチェッカ(Lettuce)アダプタ
path: component/adapters/adapters-redishealthchecker-lettuce-adaptor.json
- HealthChecker
- RedisHealthChecker
- LettuceRedisClient

### Redisストア(Lettuce)アダプタ
path: component/adapters/adapters-redisstore-lettuce-adaptor.json
- LettuceRedisClientProvider
- BasicApplicationInitializer
- BasicApplicationDisposer
- LettuceRedisClient
- LettuceSimpleRedisClient
- LettuceMasterReplicaRedisClient
- LettuceClusterRedisClient
- ComponentFactory
- Initializable
- Disposable
- SessionEntry
- JavaSerializeStateEncoder

### ルーティングアダプタ
path: component/adapters/adapters-router-adaptor.json
- RoutesMapping
- PathOptionsProviderRoutesMapping
- JaxRsPathOptionsProvider
- JaxRsHttpRequest
- PathOptionsFormatter

### ウェブアプリケーション Thymeleafアダプタ
path: component/adapters/adapters-web-thymeleaf-adaptor.json
- ThymeleafResponseWriter
- HttpResponseHandler
- HttpResponse

### HTTPエラー制御ハンドラ
path: component/handlers/handlers-HttpErrorHandler.json
- nablarch.fw.web.handler.HttpErrorHandler
- HttpResponse
- nablarch.fw.NoMoreHandlerException
- nablarch.fw.web.HttpErrorResponse
- HttpErrorResponse
- ApplicationException
- ErrorMessages
- nablarch.fw.Result.Error
- Error
- writeFailureLogPattern
- defaultPage
- defaultPages

### InjectForm インターセプタ
path: component/handlers/handlers-InjectForm.json
- InjectForm
- nablarch.common.web.interceptor.InjectForm
- OnError

### サービス提供可否チェックハンドラ
path: component/handlers/handlers-ServiceAvailabilityCheckHandler.json
- ServiceAvailability
- nablarch.common.availability.ServiceAvailabilityCheckHandler
- InternalRequestIdAttribute
- ThreadContext
- ServiceUnavailable
- ServiceAvailabilityCheckHandler.setUsesInternalRequestId

### セッション変数保存ハンドラ
path: component/handlers/handlers-SessionStoreHandler.json
- nablarch.common.web.session.SessionStoreHandler
- SessionManager
- sessionManager
- HttpErrorResponse
- HttpSessionManagedExpiration
- expiration
- DbManagedExpiration
- DbManagedExpiration.userSessionSchema
- UserSessionSchema

### リクエストボディ変換ハンドラ
path: component/handlers/handlers-body-convert-handler.json
- nablarch.fw.jaxrs.BodyConvertHandler
- bodyConverters
- BodyConverter

### CORSプリフライトリクエストハンドラ
path: component/handlers/handlers-cors-preflight-request-handler.json
- CorsResponseFinisher
- nablarch.fw.jaxrs.CorsPreflightRequestHandler
- HttpResponse
- Cors
- BasicCors

### CSRFトークン検証ハンドラ
path: component/handlers/handlers-csrf-token-verification-handler.json
- CsrfTokenUtil
- nablarch.fw.web.handler.CsrfTokenVerificationHandler
- CsrfTokenGenerator
- UUIDv4CsrfTokenGenerator
- VerificationTargetMatcher
- HttpMethodVerificationTargetMatcher
- VerificationFailureHandler
- BadRequestVerificationFailureHandler
- NopHandler
- CsrfTokenUtil.regenerateCsrfToken

### データリードハンドラ
path: component/handlers/handlers-data-read-handler.json
- NoMoreRecord
- nablarch.fw.handler.DataReadHandler
- ExecutionContext
- DataReader

### データベース接続管理ハンドラ
path: component/handlers/handlers-database-connection-management-handler.json
- nablarch.common.handler.DbConnectionManagementHandler
- connectionFactory
- ConnectionFactory
- connectionName
- DbConnection

### ループ制御ハンドラ
path: component/handlers/handlers-dbless-loop-handler.json
- nablarch.fw.handler.DbLessLoopHandler

### プロセス多重起動防止ハンドラ
path: component/handlers/handlers-duplicate-process-check-handler.json
- nablarch.fw.handler.DuplicateProcessCheckHandler
- DuplicateProcessCheckHandler
- BasicDuplicateProcessChecker
- DuplicateProcessChecker

### 出力ファイル開放ハンドラ
path: component/handlers/handlers-file-record-writer-dispose-handler.json
- FileRecordWriterHolder
- nablarch.common.io.FileRecordWriterDisposeHandler

### 内部フォーワードハンドラ
path: component/handlers/handlers-forwarding-handler.json
- nablarch.fw.web.handler.ForwardingHandler

### グローバルエラーハンドラ
path: component/handlers/handlers-global-error-handler.json
- nablarch.fw.handler.GlobalErrorHandler
- ServiceError
- Result.Error
- InternalError

### ヘルスチェックエンドポイントハンドラ
path: component/handlers/handlers-health-check-endpoint-handler.json
- DB
- nablarch.fw.web.handler.HealthCheckEndpointHandler
- HttpResponse
- HealthChecker
- HealthCheckResponseBuilder

### ホットデプロイハンドラ
path: component/handlers/handlers-hot-deploy-handler.json
- nablarch.fw.hotdeploy.HotDeployHandler
- targetPackages

### HTTPアクセスログハンドラ
path: component/handlers/handlers-http-access-log-handler.json
- nablarch.common.web.handler.HttpAccessLogHandler
- ThreadContext

### HTTP文字エンコード制御ハンドラ
path: component/handlers/handlers-http-character-encoding-handler.json
- nablarch.fw.web.handler.HttpCharacterEncodingHandler
- defaultEncoding
- appendResponseCharacterEncoding
- resolveRequestEncoding
- resolveResponseEncoding

### HTTPメッセージングエラー制御ハンドラ
path: component/handlers/handlers-http-messaging-error-handler.json
- nablarch.fw.messaging.handler.HttpMessagingErrorHandler
- HttpResponse
- nablarch.fw.NoMoreHandlerException
- nablarch.fw.web.HttpErrorResponse
- HttpErrorResponse
- nablarch.fw.Result.Error
- Error
- nablarch.core.message.ApplicationException
- nablarch.fw.messaging.MessagingException
- writeFailureLogPattern

### HTTPメッセージングリクエスト変換ハンドラ
path: component/handlers/handlers-http-messaging-request-parsing-handler.json
- HttpRequest
- RequestMessage
- nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler
- DataRecordFormatter
- StructuredFwHeaderDefinition
- nablarch.fw.results.RequestEntityTooLarge
- nablarch.fw.messaging.MessagingException
- nablarch.core.dataformat.InvalidDataFormatException

### HTTPメッセージングレスポンス変換ハンドラ
path: component/handlers/handlers-http-messaging-response-building-handler.json
- nablarch.fw.messaging.handler.HttpMessagingResponseBuildingHandler
- HTTPレスポンスオブジェクト
- InterSystemMessage.getFormatter()
- DataRecordFormatterSupport
- StructuredFwHeaderDefinition

### HTTPリクエストディスパッチハンドラ
path: component/handlers/handlers-http-request-java-package-mapping.json
- nablarch.fw.web.handler.HttpRequestJavaPackageMapping

### HTTPレスポンスハンドラ
path: component/handlers/handlers-http-response-handler.json
- HttpResponse
- nablarch.fw.web.handler.HttpResponseHandler
- ResourceLocator
- getScheme() メソッド
- getStatusCode()
- CustomResponseWriter
- DirectoryBasedResourcePathRule
- FilenameBasedResourcePathRule
- ResourcePathRule

### HTTPリライトハンドラ
path: component/handlers/handlers-http-rewrite-handler.json
- nablarch.fw.web.handler.HttpRewriteHandler
- 本ハンドラ
- HttpRequestRewriteRule
- ContentPathRewriteRule
- RewriteRule

### HTTPアクセスログ（RESTfulウェブサービス用）ハンドラ
path: component/handlers/handlers-jaxrs-access-log-handler.json
- nablarch.fw.jaxrs.JaxRsAccessLogHandler
- ThreadContext

### Jakarta RESTful Web Servcies Bean Validationハンドラ
path: component/handlers/handlers-jaxrs-bean-validation-handler.json
- ApplicationException
- nablarch.fw.jaxrs.JaxRsBeanValidationHandler

### Jakarta RESTful Web Servicesレスポンスハンドラ
path: component/handlers/handlers-jaxrs-response-handler.json
- nablarch.fw.jaxrs.JaxRsResponseHandler
- errorResponseBuilder
- ErrorResponseBuilder
- HttpErrorResponse
- HttpResponse
- errorLogWriter
- JaxRsErrorLogWriter
- ResponseFinisher
- AdoptHandlerResponseFinisher

### 携帯端末アクセスハンドラ
path: component/handlers/handlers-keitai-access-handler.json
- nablarch.fw.web.handler.KeitaiAccessHandler

### トランザクションループ制御ハンドラ
path: component/handlers/handlers-loop-handler.json
- nablarch.fw.handler.LoopHandler
- transactionFactory
- TransactionFactory
- transactionName
- DbConnectionManagementHandler
- commitInterval
- TransactionEventCallback
- transactionNormalEnd
- transactionAbnormalEnd

### 共通起動ランチャ
path: component/handlers/handlers-main.json
- CommandLine
- LauncherLogFormatter
- Main
- ApplicationSettingLogFormatter
- nablarch.fw.launcher.Main
- Mainクラス
- Request
- ExecutionContext
- Result.Error

### 電文応答制御ハンドラ
path: component/handlers/handlers-message-reply-handler.json
- ResponseMessage
- nablarch.fw.messaging.handler.MessageReplyHandler
- StandardFwHeaderDefinition

### 再送電文制御ハンドラ
path: component/handlers/handlers-message-resend-handler.json
- nablarch.fw.messaging.handler.MessageResendHandler
- SentMessageTableSchema
- InterSystemMessage
- ResponseMessage
- sentMessageTableSchemaプロパティ
- StandardFwHeaderDefinition

### メッセージングコンテキスト管理ハンドラ
path: component/handlers/handlers-messaging-context-handler.json
- nablarch.fw.messaging.handler.MessagingContextHandler
- messagingProvider
- MessagingProvider

### マルチスレッド実行制御ハンドラ
path: component/handlers/handlers-multi-thread-execution-handler.json
- MultiStatus
- nablarch.fw.handler.MultiThreadExecutionHandler
- ExecutionHandlerCallback

### マルチパートリクエストハンドラ
path: component/handlers/handlers-multipart-handler.json
- nablarch.fw.web.upload.MultipartHandler
- UploadSettings
- HttpRequest

### Nablarchカスタムタグ制御ハンドラ
path: component/handlers/handlers-nablarch-tag-handler.json
- CustomTagConfig
- nablarch.common.web.handler.NablarchTagHandler
- NablarchTagHandler

### ノーマライズハンドラ
path: component/handlers/handlers-normalize-handler.json
- nablarch.fw.web.handler.NormalizationHandler
- TrimNormalizer
- Normalizer

### OnDoubleSubmissionインターセプタ
path: component/handlers/handlers-on-double-submission.json
- nablarch.common.web.token.OnDoubleSubmission
- OnDoubleSubmission
- BasicDoubleSubmissionHandler
- DoubleSubmissionHandler

### OnErrorインターセプタ
path: component/handlers/handlers-on-error.json
- OnError
- nablarch.fw.web.interceptor.OnError
- HttpErrorResponse

### OnErrorsインターセプタ
path: component/handlers/handlers-on-errors.json
- OnErrors
- nablarch.fw.web.interceptor.OnErrors
- OnError

### 認可チェックハンドラ
path: component/handlers/handlers-permission-check-handler.json
- PermissionFactory
- nablarch.common.permission.PermissionCheckHandler
- InternalRequestIdAttribute
- Permission
- Forbidden(403)
- PermissionCheckHandler.setUsesInternalRequestId
- PermissionCheckHandler.setIgnoreRequestIds

### POST再送信防止ハンドラ
path: component/handlers/handlers-post-resubmit-prevent-handler.json
- nablarch.fw.web.post.PostResubmitPreventHandler

### プロセス常駐化ハンドラ
path: component/handlers/handlers-process-resident-handler.json
- nablarch.fw.handler.ProcessResidentHandler
- RetryableException
- dataWatchInterval
- ProcessStop
- normalEndExceptions
- ServiceUnavailable
- RetryUtil
- abnormalEndExceptions
- ProcessAbnormalEnd

### プロセス停止制御ハンドラ
path: component/handlers/handlers-process-stop-handler.json
- nablarch.fw.handler.BasicProcessStopHandler
- BasicProcessStopHandler

### リクエストハンドラエントリ
path: component/handlers/handlers-request-handler-entry.json
- nablarch.fw.RequestHandlerEntry

### リクエストディスパッチハンドラ
path: component/handlers/handlers-request-path-java-package-mapping.json
- Request
- nablarch.fw.handler.RequestPathJavaPackageMapping
- JavaPackageMappingEntry

### リクエストスレッド内ループ制御ハンドラ
path: component/handlers/handlers-request-thread-loop-handler.json
- nablarch.fw.handler.RequestThreadLoopHandler
- リトライ可能例外(Retryable)
- ServiceUnavailable
- ProcessStop
- ProcessAbnormalEnd
- ServiceError
- Result.Error

### リソースマッピングハンドラ
path: component/handlers/handlers-resource-mapping.json
- nablarch.fw.web.handler.ResourceMapping

### リトライハンドラ
path: component/handlers/handlers-retry-handler.json
- Retryable
- RetryContext
- リトライ回数による上限設定
- 経過時間による上限設定
- nablarch.fw.handler.RetryHandler

### セキュアハンドラ
path: component/handlers/handlers-secure-handler.json
- HttpResponse
- nablarch.fw.web.handler.SecureHandler
- FrameOptionsHeader
- ContentTypeOptionsHeader
- XssProtectionHeader
- ReferrerPolicyHeader
- CacheControlHeader
- SecureResponseHeader
- SecureResponseHeaderSupport
- SecureHandler

### セッション並行アクセスハンドラ
path: component/handlers/handlers-session-concurrent-access-handler.json
- nablarch.fw.web.handler.SessionConcurrentAccessHandler

### ステータスコード→プロセス終了コード変換ハンドラ
path: component/handlers/handlers-status-code-convert-handler.json
- nablarch.fw.handler.StatusCodeConvertHandler

### スレッドコンテキスト変数削除ハンドラ
path: component/handlers/handlers-thread-context-clear-handler.json
- nablarch.common.handler.threadcontext.ThreadContextClearHandler

### スレッドコンテキスト変数管理ハンドラ
path: component/handlers/handlers-thread-context-handler.json
- nablarch.common.handler.threadcontext.ThreadContextHandler
- ThreadContextAttributeインタフェース
- RequestIdAttribute
- InternalRequestIdAttribute
- UserIdAttribute
- UserIdAttributeInSessionStore
- LanguageAttribute
- HttpLanguageAttribute
- LanguageAttributeInHttpCookie
- LanguageAttributeInHttpSession
- TimeZoneAttribute
- TimeZoneAttributeInHttpCookie
- TimeZoneAttributeInHttpSession
- ExecutionIdAttribute
- ThreadContext
- LanguageAttributeInHttpUtil
- TimeZoneAttributeInHttpUtil

### トランザクション制御ハンドラ
path: component/handlers/handlers-transaction-management-handler.json
- nablarch.common.handler.TransactionManagementHandler
- transactionFactory
- TransactionFactory
- transactionName
- DbConnectionManagementHandler
- transactionCommitExceptions
- TransactionEventCallback
- transactionNormalEnd
- transactionAbnormalEnd

### UseTokenインターセプタ
path: component/handlers/handlers-use-token.json
- nablarch.common.web.token.UseToken
- UseToken

### ハンドラによる認可チェック
path: component/libraries/libraries-authorization-permission-check.json
- BasicPermissionFactory
- Permission
- PermissionUtil.getPermission

### BeanUtil
path: component/libraries/libraries-bean-util.json
- BeanUtil
- Javadoc
- Converter
- ExtensionConverter
- ConversionManager
- BasicConversionManager
- CopyOption
- CopyOptions
- CopyOptions.Builder
- BeanUtil.setProperty
- BeanUtil.copy

### Bean Validation
path: component/libraries/libraries-bean-validation.json
- NablarchMessageInterpolator
- @Required
- DomainManager
- getDomainBean
- @Domain
- RangedCharsetDef
- LiteralCharsetDef
- CompositeCharsetDef
- @SystemChar
- charsetDef
- CachingCharsetDef
- SystemCharConfig
- ValidationUtil
- ApplicationException
- Size
- BeanValidationStrategy
- ItemNamedConstraintViolationConverterFactory
- ValidatorUtil
- HttpRequest

### コード管理
path: component/libraries/libraries-code.json
- BasicCodeManager
- BasicStaticDataCache
- loadOnStartup
- BasicCodeLoader
- CodePatternSchema.patternColumnNames
- CodeUtil
- nablarch.common.code.validator.ee.CodeValue
- nablarch.common.code.validator.CodeValue

### データバインド
path: component/libraries/libraries-data-bind.json
- BeanUtil
- DataBindConfig
- ObjectMapperFactory
- ObjectMapper
- LineNumber
- FileResponse
- PartInfo
- Csv
- CsvFormat
- CsvDataBindConfig
- FixedLength
- Field
- FixedLengthDataBindConfig
- FixedLengthDataBindConfigBuilder
- MultiLayout
- RecordIdentifier

### 汎用データフォーマット
path: component/libraries/libraries-data-format.json
- BeanUtil
- 数値型
- 真偽値型
- データタイプ
- FileRecordWriterHolder
- DataRecordResponse
- HttpRequest
- FilePathSetting
- FormatterFactory
- DataRecordFormatter
- UploadHelper
- setUpMessageIdOnError
- validateWith
- importWith
- XmlDataParser
- CharacterReplacementManager
- configList
- CharacterReplacementConfig
- typeName
- DataType
- FixedLengthConvertorFactory
- VariableLengthConvertorFactory
- JsonDataConvertorFactory
- XmlDataConvertorFactory
- FixedLengthConvertorSetting
- fixedLengthConvertorFactory
- VariableLengthConvertorSetting
- variableLengthConvertorFactory
- JsonDataConvertorSetting
- jsonDataConvertorFactory
- XmlDataConvertorSetting
- xmlDataConvertorFactory
- XmlDataBuilder

### データベースアクセス(JDBCラッパー)
path: component/libraries/libraries-database.json
- Dialect
- supportsIdentity
- supportsIdentityWithBatchInsert
- supportsSequence
- supportsOffset
- isDuplicateException
- isTransactionTimeoutError
- buildSequenceGeneratorSql
- ResultSetConvertor
- getResultSetConvertor
- convertPaginationSql
- convertCountSql(String)
- convertCountSql(String, Object, StatementFactory)
- getPingSql
- BasicDbConnectionFactoryForDataSource
- BasicDbConnectionFactoryForJndi
- DefaultDialect
- dialect
- BasicStatementFactory
- BasicSqlLoader
- DbConnectionContext
- AppDbConnection
- SqlPStatement
- SqlCStatement
- ParameterizedSqlPStatement
- BeanUtil
- SqlRow
- AutoPropertyHandler
- 検索結果オブジェクト
- DbAccessException
- DbConnectionException
- SqlStatementException
- DuplicateStatementException
- SimpleDbTransactionManager
- connectionFactory
- ConnectionFactory
- transactionFactory
- TransactionFactory
- SimpleDbTransactionExecutor
- InMemoryResultSetCache
- BasicExpirationSetting
- CacheableStatementFactory
- expirationSetting
- resultSetCache
- TransactionManagerConnection
- SchemaReplacer
- ConnectionFactorySupport
- DbAccessExceptionFactory
- SqlStatementExceptionFactory

### 日付管理
path: component/libraries/libraries-date.json
- BasicSystemTimeProvider
- SystemTimeUtil
- BasicBusinessDateProvider
- BusinessDateUtil
- SystemTimeProvider
- BusinessDateProvider

### データベースを使用した二重サブミット防止
path: component/libraries/libraries-db-double-submit.json
- DbTokenManager.dbTokenSchema
- DbTokenSchema
- HttpSessionTokenManager

### 排他制御
path: component/libraries/libraries-exclusive-control.json
- BasicExclusiveControlManager
- ExclusiveControlContext
- HttpExclusiveControlUtil
- HttpExclusiveControlUtil.checkVersions
- CompositeKey
- ExclusiveControlUtil

### 障害ログの出力
path: component/libraries/libraries-failure-log.json
- FailureLogUtil
- TransactionAbnormalEnd
- ProcessAbnormalEnd
- FailureLogFormatter
- ThreadContext
- LogItem
- DataItem
- FailureJsonLogFormatter
- JsonLogFormatter

### ファイルパス管理
path: component/libraries/libraries-file-path-management.json
- FilePathSetting
- basePathSettings
- fileExtensions

### フォーマット定義ファイルの記述ルール
path: component/libraries/libraries-format-definition.json
- convertEmptyToNull
- InvalidDataFormatException
- SignedNumberStringDecimal

### フォーマッタ
path: component/libraries/libraries-format.json
- FormatterUtil
- Formatter

### サロゲートキーの採番
path: component/libraries/libraries-generator.json
- BasicDaoContextFactory
- IdGenerator

### HTTPアクセスログの出力
path: component/libraries/libraries-http-access-log.json
- HttpAccessLogFormatter
- BasicLogFormatter
- ThreadContext
- HttpAccessJsonLogFormatter
- JsonLogFormatter
- セッションを破棄
- IDを変更

### HTTPメッセージング
path: component/libraries/libraries-http-system-messaging.json
- MessagingAction
- MessageSender
- MessageSenderClient
- HttpMessagingClient
- RequestMessage.reply
- SyncMessage
- FwHeaderDefinition
- StandardFwHeaderDefinition

### HTTPアクセスログ（RESTfulウェブサービス用）の出力
path: component/libraries/libraries-jaxrs-access-log.json
- JaxRsAccessLogFormatter
- BasicLogFormatter
- ThreadContext
- MessageBodyLogTargetMatcher
- JaxRsBodyLogTargetMatcher
- LogContentMaskingFilter
- JaxRsBodyMaskingFilter
- JaxRsAccessJsonLogFormatter
- JsonLogFormatter
- セッションを破棄
- IDを変更

### ログ出力
path: component/libraries/libraries-log.json
- LogWriter
- LogFormatter
- Logger
- LoggerFactory
- BasicLogger
- BasicLoggerFactory
- FileLogWriter (ファイルへ出力。ログのローテーション。)
- SynchronousFileLogWriter (複数プロセスから1ファイルへの出力)
- StandardOutputLogWriter (標準出力へ出力)
- LogPublisher (任意のリスナーへ出力)
- BasicLogFormatter (パターン文字列によるフォーマット)
- DateRotatePolicy (日時によるログのローテーション)
- FileSizeRotatePolicy (ファイルサイズによるログのローテーション)
- SynchronousFileLogWriter
- LoggerManager
- FileUtil
- LogLevel
- BasicLogFormatter
- ThreadContext
- FileSizeRotatePolicy
- RotatePolicy
- DateRotatePolicy
- LogWriterSupport
- LogLevelLabelProvider
- LogItem
- FileLogWriter
- needsToWrite
- JsonLogFormatter
- FailureJsonLogFormatter
- SqlJsonLogFormatter
- PerformanceJsonLogFormatter
- HttpAccessJsonLogFormatter
- JaxRsAccessJsonLogFormatter
- MessagingJsonLogFormatter
- ApplicationSettingLogFormatter
- ApplicationSettingJsonLogFormatter
- LauncherLogFormatter
- LauncherJsonLogFormatter
- CommitLogger
- BasicCommitLogger
- JsonCommitLogger
- LogPublisher
- LogContext
- LogListener
- removeListener(LogListener)
- removeAllListeners()

### メール送信
path: component/libraries/libraries-mail.json
- MailRequestTable
- MailRecipientTable
- MailAttachedFileTable
- MailTemplateTable
- MailConfig
- MailConfigのJavadoc
- MailRequester
- MailRequestConfig
- MailSessionConfig
- MailUtil
- FreeTextMailContext
- TemplateMailContext
- AttachedFile
- MailSender
- InvalidCharacterException
- MailSenderのJavadoc

### メッセージ管理
path: component/libraries/libraries-message.json
- PropertiesStringResourceLoader.locales
- PropertiesStringResourceLoader.defaultLocale
- ThreadContext
- PropertiesStringResourceLoader
- ApplicationException
- MessageUtil
- Message
- MessageLevel
- WebUtil.notifyMessages
- WebUtil
- BasicStringResourceLoader
- MessageFormatter
- BasicMessageFormatter
- JavaMessageFormatBaseMessageFormatter

### メッセージングログの出力
path: component/libraries/libraries-messaging-log.json
- MessagingLogFormatter
- MessagingJsonLogFormatter
- JsonLogFormatter

### MOMメッセージング
path: component/libraries/libraries-mom-system-messaging.json
- MessagingProvider
- JmsMessagingProvider
- MessageReader
- FwHeaderReader
- messageReader
- AsyncMessageSendAction
- AsyncMessageSendActionSettings
- MessageSender
- SyncMessage
- MessageSenderSettings
- SyncMessageConvertor
- AsyncMessageReceiveAction
- RequestMessage
- AsyncMessageReceiveActionSettings
- MessagingAction
- FwHeaderDefinition
- StandardFwHeaderDefinition
- fwHeaderDefinition

### Nablarch Validation
path: component/libraries/libraries-nablarch-validation.json
- ValidationManager
- DomainValidationHelper
- DomainValidator
- domainAnnotationプロパティ
- domainValidationHelperプロパティ
- validatorsプロパティ
- @PropertyName
- @Digits
- @NumberRange
- ValidationUtil
- @ValidateFor
- DirectCallableValidator
- @SystemChar
- SystemCharValidator
- ValidationContext
- @ValidationTarget
- size
- sizeKey
- WebUtil
- WebUtil.containsPropertyKeyValue
- WebUtil.containsPropertyKey
- @Validation
- Validator
- Convertor
- FormCreator
- ValidationManager.formCreator

### パフォーマンスログの出力
path: component/libraries/libraries-performance-log.json
- PerformanceLogUtil
- PerformanceLogFormatter
- PerformanceJsonLogFormatter
- JsonLogFormatter

### システムリポジトリ
path: component/libraries/libraries-repository.json
- ExternalizedComponentDefinitionLoader
- SystemPropertyExternalizedLoader
- OsEnvironmentVariableExternalizedLoader
- ComponentFactory
- SystemRepositoryComponent
- AnnotationComponentDefinitionLoader
- getBasePackage
- ConfigValue
- ComponentRef
- ConstructorInjectionComponentCreator
- newComponentCreator
- ComponentCreator
- DelegateFactory
- DispatchHandler
- Initializable
- initialize
- BasicApplicationInitializer
- Disposable
- dispose
- BasicApplicationDisposer
- addDisposable
- DisposableAdaptor
- SystemRepository

### アノテーションによる認可チェック
path: component/libraries/libraries-role-check.json
- BasicRoleEvaluator
- SessionStoreUserRoleResolver
- インターセプタ
- CheckRole
- SessionStoreUserRoleUtil
- Forbidden
- CheckRoleLogger
- BasicApplicationInitializer
- CheckRoleUtil
- RoleEvaluator
- SystemRepository
- ThreadContext
- UserRoleResolver

### サービス提供可否チェック
path: component/libraries/libraries-service-availability.json
- BasicServiceAvailability
- ServiceAvailabilityUtil

### セッションストア
path: component/libraries/libraries-session-store.json
- SessionUtil
- ExecutionContext
- Java標準のシリアライズによる直列化(デフォルト)
- Java標準のシリアライズによる直列化、および暗号化
- Jakarta XML BindingによるXMLベースの直列化
- SessionManager
- DbStore.userSessionSchema
- UserSessionSchema
- SessionKeyNotFoundException
- SessionStore
- SessionManager.availableStores

### SQLログの出力
path: component/libraries/libraries-sql-log.json
- SqlLogFormatter
- SqlPStatement
- SqlStatement
- SqlJsonLogFormatter
- JsonLogFormatter

### Webアプリケーションをステートレスにする
path: component/libraries/libraries-stateless-web-app.json
- LanguageAttributeInHttpSession
- TimeZoneAttributeInHttpSession
- UserIdAttribute
- LanguageAttributeInHttpCookie
- TimeZoneAttributeInHttpCookie
- UserIdAttributeInSessionStore
- WebFrontController

### 静的データのキャッシュ
path: component/libraries/libraries-static-data-cache.json
- StaticDataLoader
- BasicStaticDataCache
- BasicStaticDataCache.loader
- StaticDataCache
- BasicStaticDataCache.loadOnStartup

### タグリファレンス
path: component/libraries/libraries-tag-reference.json
- ValidationResultMessage

### Jakarta Server Pagesカスタムタグ
path: component/libraries/libraries-tag.json
- CustomTagConfig
- Encryptor
- CompositeKeyConvertor
- CompositeKeyArrayConvertor
- CompositeKey
- submitLinkDisabledJspプロパティ
- displayMethodプロパティ
- popupWindowNameプロパティ
- HttpResponse
- StreamResponse
- DataRecordResponse
- SqlRow
- UUIDV4TokenGenerator
- safeTagsプロパティ
- safeAttributesプロパティ
- ThreadContext
- Nablarch独自のバリデーションが提供する年月日コンバータ
- 年月日コンバータ
- YYYYMMDD
- BigDecimalConvertor
- IntegerConvertor
- LongConvertor
- ApplicationException
- CodeUtil
- ResourcePathRule
- dynamicBooleanAttributesプロパティ
- ValueFormatter
- DisplayControlChecker
- displayControlCheckersプロパティ
- TokenGenerator
- portプロパティ
- securePortプロパティ
- hostプロパティ

### トランザクション管理
path: component/libraries/libraries-transaction.json
- JdbcTransactionFactory
- Transaction
- TransactionTimeoutException
- TransactionFactory

### ユニバーサルDAO
path: component/libraries/libraries-universal-dao.json
- nablarch.common.dao.UniversalDao
- BasicDaoContextFactory
- UniversalDao
- DeferredEntityList
- Pagination
- EntityList
- Dialect
- batchInsert
- batchUpdate
- batchDelete
- OnError
- SimpleDbTransactionManager
- connectionFactory
- ConnectionFactory
- transactionFactory
- TransactionFactory
- UniversalDao.Transaction
- DatabaseMetaDataExtractor
- nablarch.core.db.dialect.H2Dialect

### 汎用ユーティリティ
path: component/libraries/libraries-utility.json
- DateUtil
- FileUtil
- ObjectUtil
- StringUtil
- BeanUtil
- Base64Util
- BinaryUtil

### Bean ValidationとNablarch Validationの機能比較
path: component/libraries/libraries-validation-functional-comparison.json
- ValidatorUtil
- BeanUtil

## development-tools

### データベースを使用するクラスのテスト
path: development-tools/testing-framework/testing-framework-02-DbAccessTest.json
- SqlPStatement

### 目的別API使用方法
path: development-tools/testing-framework/testing-framework-03-Tips.json
- IdGenerator

### 取引単体テストの実施方法
path: development-tools/testing-framework/testing-framework-03-dealunittest-rest.json
- RequestResponseProcessor
- RequestResponseCookieManager
- NablarchSIDManager
- ComplexRequestResponseProcessor

### JUnit 5用拡張機能
path: development-tools/testing-framework/testing-framework-JUnit5-Extension.json
- TestSupport
- TestSupportExtension
- NablarchTest
- BatchRequestTestSupport
- BatchRequestTestExtension
- BatchRequestTest
- DbAccessTestSupport
- DbAccessTestExtension
- DbAccessTest
- EntityTestSupport
- EntityTestExtension
- EntityTest
- BasicHttpRequestTestTemplate
- BasicHttpRequestTestExtension
- BasicHttpRequestTest
- HttpRequestTestSupport
- HttpRequestTestExtension
- HttpRequestTest
- RestTestSupport
- RestTestExtension
- RestTest
- SimpleRestTestSupport
- SimpleRestTestExtension
- SimpleRestTest
- IntegrationTestSupport
- IntegrationTestExtension
- IntegrationTest
- MessagingReceiveTestSupport
- MessagingReceiveTestExtension
- MessagingReceiveTest
- MessagingRequestTestSupport
- MessagingRequestTestExtension
- MessagingRequestTest
- AbstractHttpRequestTestTemplate
- TestEventDispatcherExtension
- TestEventDispatcher

### リクエスト単体テスト（RESTfulウェブサービス）
path: development-tools/testing-framework/testing-framework-RequestUnitTest-rest.json
- Javadoc

### Nablarch OpenAPI Generator
path: development-tools/toolbox/toolbox-NablarchOpenApiGenerator.json
- HttpResponse
- JaxRsHttpRequest
- ExecutionContext
- EntityResponse
- Required
- NumberRange(min = {minimum}, max = {maximum})
- DecimalRange(min = "{minimum}", max = "{maximum}")
- Length(min = {minLength}, max = {maxLength})
- Size(min = {minItems}, max = {maxItems})
- Domain("{domainName}")
- BeanUtil

## processing-pattern

### アーキテクチャ概要
path: processing-pattern/db-messaging/db-messaging-architecture.json
- ProcessStop
- バッチ用のDatabaseRecordReader
- DatabaseTableQueueReader
- BatchAction (汎用的なバッチアクション)

### データベースをキューとしたメッセージングのエラー処理
path: processing-pattern/db-messaging/db-messaging-error-processing.json
- transactionFailure
- ProcessAbnormalEnd

### 機能詳細
path: processing-pattern/db-messaging/db-messaging-feature-details.json
- DatabaseTableQueueReader (データベースのテーブルをキューとして扱うリーダ)

### テーブルキューを監視し未処理データを取り込むアプリケーションの作成
path: processing-pattern/db-messaging/db-messaging-table-queue.json
- BatchAction
- SqlRow
- DatabaseTableQueueReader
- createReader
- DatabaseRecordReader
- SqlPStatement
- DatabaseRecordListener
- handle
- Result.Success
- transactionSuccess
- transactionFailure

### アプリケーションの責務配置
path: processing-pattern/http-messaging/http-messaging-application-design.json
- RequestMessage
- ResponseMessage

### アーキテクチャ概要
path: processing-pattern/http-messaging/http-messaging-architecture.json
- RequestMessage
- MessagingAction (同期応答メッセージング用アクションのテンプレートクラス)

### 機能詳細
path: processing-pattern/http-messaging/http-messaging-feature-details.json
- MessagingAction

### 登録機能の作成
path: processing-pattern/http-messaging/http-messaging-getting-started-save.json
- MessagingAction
- RequestMessage
- UniversalDao
- ResponseMessage

### アーキテクチャ概要
path: processing-pattern/jakarta-batch/jakarta-batch-architecture.json
- StepScoped
- NablarchStepListenerExecutor
- NablarchItemWriteListenerExecutor
- ジョブの起動、終了ログを出力するリスナー
- 同一ジョブの多重起動防止リスナー
- ステップの開始、終了ログを出力するリスナー
- データベースへ接続するリスナー
- トランザクションを制御するリスナー
- Chunkの進捗ログを出力するリスナー(非推奨)

### データベースを入力とするChunkステップ
path: processing-pattern/jakarta-batch/jakarta-batch-database-reader.json
- BaseDatabaseItemReader

### データを導出するバッチの作成(Chunkステップ)
path: processing-pattern/jakarta-batch/jakarta-batch-getting-started-chunk.json
- UniversalDao

### 運用方針
path: processing-pattern/jakarta-batch/jakarta-batch-operation-policy.json
- JobExecutor
- Main

### 運用担当者向けのログ出力
path: processing-pattern/jakarta-batch/jakarta-batch-operator-notice-log.json
- OperationLogger

### 進捗状況のログ出力
path: processing-pattern/jakarta-batch/jakarta-batch-progress-log.json
- inputCount
- outputProgressInfo
- ProgressManager

### Jakarta Batchアプリケーションの起動
path: processing-pattern/jakarta-batch/jakarta-batch-run-batch-application.json
- nablarch.fw.batch.ee.Main

### アプリケーションの責務配置
path: processing-pattern/mom-messaging/mom-messaging-application-design.json
- FwHeaderReader
- MessageReader
- RequestMessage
- ResponseMessage
- Success

### アーキテクチャ概要
path: processing-pattern/mom-messaging/mom-messaging-architecture.json
- FwHeaderReader
- MessageReader
- ResponseMessage
- ステータスコード→プロセス終了コード変換ハンドラ(StatusCodeConvertHandler)
- ProcessStop
- FwHeaderReader (電文からフレームワーク制御ヘッダの読み込み)
- MessageReader (MQから電文の読み込み)
- DataReader
- MessagingAction (同期応答メッセージング用アクションのテンプレートクラス)
- AsyncMessageReceiveAction (応答不要メッセージングのアクションクラス)

### 機能詳細
path: processing-pattern/mom-messaging/mom-messaging-feature-details.json
- FwHeaderReader (電文からフレームワーク制御ヘッダの読み込み)
- MessageReader (MQから電文の読み込み)

### アプリケーションの責務配置
path: processing-pattern/nablarch-batch/nablarch-batch-application-design.json
- DataReader
- Result
- Success

### アーキテクチャ概要
path: processing-pattern/nablarch-batch/nablarch-batch-architecture.json
- データリーダ(DataReader)
- ディスパッチハンドラ(DispatchHandler)
- Result
- ステータスコード→プロセス終了コード変換ハンドラ(StatusCodeConvertHandler)
- ProcessStop
- DatabaseRecordReader (データベース読み込み)
- FileDataReader (ファイル読み込み)
- ValidatableFileDataReader (バリデージョン機能付きファイル読み込み)
- ResumeDataReader (レジューム機能付き読み込み)
- DataReader
- BatchAction (汎用的なバッチアクションのテンプレートクラス)
- FileBatchAction (ファイル入力のバッチアクションのテンプレートクラス)
- NoInputDataBatchAction (入力データを使用しないバッチアクションのテンプレートクラス)
- AsyncMessageSendAction (応答不要メッセージ送信用のアクションクラス)

### 機能詳細
path: processing-pattern/nablarch-batch/nablarch-batch-feature-details.json
- DatabaseRecordReader (データベース読み込み)
- FileDataReader (ファイル読み込み)
- ValidatableFileDataReader (バリデージョン機能付きファイル読み込み)
- ResumeDataReader (レジューム機能付き読み込み)

### Jakarta Batchに準拠したバッチアプリケーションとNablarchバッチアプリケーションとの機能比較
path: processing-pattern/nablarch-batch/nablarch-batch-functional-comparison.json
- Javadocへ
- ResumeDataReader (レジューム機能付き読み込み)

### ファイルをDBに登録するバッチの作成
path: processing-pattern/nablarch-batch/nablarch-batch-getting-started-nablarch-batch.json
- Csv
- CsvFormat
- LineNumber
- DataReader
- ObjectMapper
- BatchAction
- UniversalDao

### Nablarchバッチアプリケーションのエラー処理
path: processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-error-process.json
- ResumeDataReader (レジューム機能付き読み込み)
- TransactionAbnormalEnd
- ProcessAbnormalEnd

### バッチアプリケーションで実行中の状態を保持する
path: processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-retention-state.json
- ExecutionContext

### Jakarta RESTful Web Servicesサポート/Jakarta RESTful Web Services/HTTPメッセージングの機能比較
path: processing-pattern/restful-web-service/restful-web-service-functional-comparison.json
- ○

### 登録機能の作成
path: processing-pattern/restful-web-service/restful-web-service-getting-started-create.json
- BeanUtil
- HttpResponse

### 検索機能の作成
path: processing-pattern/restful-web-service/restful-web-service-getting-started-search.json
- JaxRsHttpRequest
- BeanUtil
- ValidatorUtil

### 更新機能の作成
path: processing-pattern/restful-web-service/restful-web-service-getting-started-update.json
- BeanUtil
- HttpResponse
- ErrorResponseBuilder
- NoDataException

### リソース(アクション)クラスの実装に関して
path: processing-pattern/restful-web-service/restful-web-service-resource-signature.json
- JaxRsHttpRequest
- ExecutionContext
- HttpResponse
- BeanUtil
- EntityResponse

### ウェブサービス編
path: processing-pattern/restful-web-service/restful-web-service-web-service.json
- MessagingException

### アーキテクチャ概要
path: processing-pattern/web-application/web-application-architecture.json
- HttpResponse

### 登録内容の確認
path: processing-pattern/web-application/web-application-client-create2.json
- @InjectForm
- Required
- InjectForm
- OnError
- SessionUtil
- BeanUtil

### 登録内容確認画面から登録画面へ戻る
path: processing-pattern/web-application/web-application-client-create3.json
- BeanUtil

### データベースへの登録
path: processing-pattern/web-application/web-application-client-create4.json
- OnDoubleSubmission

### バリデーションエラーのメッセージを画面表示する
path: processing-pattern/web-application/web-application-error-message.json
- ErrorMessages

### エラー時の遷移先の指定方法
path: processing-pattern/web-application/web-application-forward-error-page.json
- NoDataException
- ApplicationException

### 一括更新機能の作成
path: processing-pattern/web-application/web-application-getting-started-project-bulk-update.json
- @Required
- @Domain
- UniversalDao

### 削除機能の作成
path: processing-pattern/web-application/web-application-getting-started-project-delete.json
- UniversalDao

### ファイルダウンロード機能の作成
path: processing-pattern/web-application/web-application-getting-started-project-download.json
- @Csv
- @CsvFormat
- ObjectMapper
- FileResponse
- UniversalDao
- HttpResponse

### 検索機能の作成
path: processing-pattern/web-application/web-application-getting-started-project-search.json
- BeanUtil
- InjectForm
- UniversalDao

### 更新機能の作成
path: processing-pattern/web-application/web-application-getting-started-project-update.json
- UniversalDao
- NoDataException
- @OnDoubleSubmission
- ResourceLocator

### アップロードを用いた一括登録機能の作成
path: processing-pattern/web-application/web-application-getting-started-project-upload.json
- HttpRequest
- PartInfo
- UploadHelper
- @Csv
- @CsvFormat
- @Required
- @Domain
- LineNumber
- ObjectMapper
- ValidatorUtil
- Message
- ApplicationException
- UniversalDao

### Nablarchサーブレットコンテキスト初期化リスナー
path: processing-pattern/web-application/web-application-nablarch-servlet-context-listener.json
- NablarchServletContextListener

### その他のテンプレートエンジンを使用した画面開発
path: processing-pattern/web-application/web-application-other.json
- CustomResponseWriter

### Webフロントコントローラ
path: processing-pattern/web-application/web-application-web-front-controller.json
- WebFrontController
- handlerQueue
- RepositoryBasedWebFrontController
