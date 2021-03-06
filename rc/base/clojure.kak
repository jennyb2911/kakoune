# http://clojure.org
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# require lisp.kak

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](clj|cljc|cljs|cljx) %{
    set-option buffer filetype clojure
}

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/clojure regions
add-highlighter shared/clojure/code default-region group
add-highlighter shared/clojure/comment region '(?<!\\)(?:\\\\)*\K;' '$'                 fill comment
add-highlighter shared/clojure/string  region '(?<!\\)(?:\\\\)*\K"' '(?<!\\)(?:\\\\)*"' fill string

add-highlighter shared/clojure/code/ regex \b(nil|true|false)\b 0:value
add-highlighter shared/clojure/code/ regex \
    \\(?:space|tab|newline|return|backspace|formfeed|u[0-9a-fA-F]{4}|o[0-3]?[0-7]{1,2}|.)\b 0:string

# Numbers
add-highlighter shared/clojure/code/ regex [-+]?(?:0[0-7]*|0[xX][0-9a-fA-F]+|[1-9]+)N? 0:value
add-highlighter shared/clojure/code/ regex [-+]?(?:0|[1-9]\d*|(?:0|[1-9]\d*)\.\d*)(?:M|[eE][-+]?\d+)? 0:value
add-highlighter shared/clojure/code/ regex [-+]?(?:0|[1-9]\d*)/(?:0|[1-9]\d*) 0:value

hook global WinSetOption filetype=clojure %{
    set-option window extra_word_chars . / * ? + - < > ! : "'"
}

evaluate-commands %sh{
    symbol_char='[^\s()\[\]{}"\;@^`~\\%/]'
    in_core='(clojure\.core/|(?<!/))'
    keywords="
    case cond cond-> cond->> def definline definterface defmacro defmethod
    defmulti defn defn- defonce defprotocol defrecord defstruct deftype fn if
    if-let if-not if-some let letfn new ns when when-first when-let when-not
    when-some . .."

    core_fns="
    * *' + +' - -' -> ->> ->ArrayChunk ->Eduction ->Vec ->VecNode ->VecSeq / <
    <= = == > >= StackTraceElement->vec Throwable->map accessor aclone
    add-classpath add-watch agent agent-error agent-errors aget alength alias
    all-ns alter alter-meta! alter-var-root amap ancestors and any? apply
    areduce array-map as-> aset aset-boolean aset-byte aset-char aset-double
    aset-float aset-int aset-long aset-short assert assoc assoc! assoc-in
    associative? atom await await-for bases bean bigdec bigint biginteger
    binding bit-and bit-and-not bit-clear bit-flip bit-not bit-or bit-set
    bit-shift-left bit-shift-right bit-test bit-xor boolean boolean-array
    boolean? booleans bound-fn bound-fn* bound? bounded-count butlast byte
    byte-array bytes bytes?  cast cat catch char char-array char-escape-string
    char-name-string char? chars class class? clear-agent-errors
    clojure-version coll? comment commute comp comparator compare
    compare-and-set! compile complement completing concat  conj conj! cons
    constantly construct-proxy contains? count counted? create-ns
    create-struct cycle dec dec' decimal? declare dedupe default-data-readers
    delay delay? deliver denominator deref derive descendants disj disj!
    dissoc dissoc! distinct distinct? do doall dorun doseq dosync dotimes doto
    double double-array double? doubles drop drop-last drop-while eduction
    empty empty? ensure ensure-reduced enumeration-seq error-handler
    error-mode eval even? every-pred every? ex-data ex-info extend
    extend-protocol extend-type extenders extends? false? ffirst file-seq
    filter filterv finally find find-keyword find-ns find-var first flatten
    float float-array float? floats flush fn? fnext fnil for force format
    frequencies future future-call future-cancel future-cancelled?
    future-done? future? gen-class gen-interface gensym get get-in get-method
    get-proxy-class get-thread-bindings get-validator group-by halt-when hash
    hash-map hash-ordered-coll hash-set hash-unordered-coll ident? identical?
    identity ifn? import in-ns inc inc' indexed? init-proxy inst-ms inst?
    instance? int int-array int? integer? interleave intern interpose into
    into-array ints io! isa? iterate iterator-seq juxt keep keep-indexed key
    keys keyword keyword? last lazy-cat lazy-seq line-seq list list* list?
    load load-file load-reader load-string loaded-libs locking long long-array
    longs loop macroexpand macroexpand-1 make-array make-hierarchy map
    map-entry? map-indexed map? mapcat mapv max max-key memfn memoize merge
    merge-with meta methods min min-key mix-collection-hash mod monitor-enter
    monitor-exit name namespace namespace-munge nat-int? neg-int? neg? newline
    next nfirst nil? nnext not not-any? not-empty not-every? not= ns-aliases
    ns-imports ns-interns ns-map ns-name ns-publics ns-refers ns-resolve
    ns-unalias ns-unmap nth nthnext nthrest num number? numerator object-array
    odd? or parents partial partition partition-all partition-by pcalls peek
    persistent! pmap pop pop! pop-thread-bindings pos-int? pos? pr pr-str
    prefer-method prefers print print-str printf println println-str prn
    prn-str promise proxy proxy-mappings proxy-super push-thread-bindings
    pvalues qualified-ident? qualified-keyword? qualified-symbol? quot quote
    rand rand-int rand-nth random-sample range ratio? rational? rationalize
    re-find re-groups re-matcher re-matches re-pattern re-seq read read-line
    read-string reader-conditional reader-conditional? realized? record? recur
    reduce reduce-kv reduced reduced? reductions ref ref-history-count
    ref-max-history ref-min-history ref-set refer refer-clojure reify
    release-pending-sends rem remove remove-all-methods remove-method
    remove-ns remove-watch repeat repeatedly replace replicate require reset!
    reset-meta! reset-vals! resolve rest restart-agent resultset-seq reverse
    reversible? rseq rsubseq run! satisfies? second select-keys send send-off
    send-via seq seq? seqable? seque sequence sequential? set set!
    set-agent-send-executor! set-agent-send-off-executor! set-error-handler!
    set-error-mode! set-validator! set? short short-array shorts shuffle
    shutdown-agents simple-ident? simple-keyword? simple-symbol? slurp some
    some-> some->> some-fn some? sort sort-by sorted-map sorted-map-by
    sorted-set sorted-set-by sorted? special-symbol? spit split-at split-with
    str string? struct struct-map subs subseq subvec supers swap! swap-vals!
    symbol symbol? sync tagged-literal tagged-literal? take take-last take-nth
    take-while test the-ns thread-bound? throw time to-array to-array-2d
    trampoline transduce transient tree-seq true? try type unchecked-add
    unchecked-add-int unchecked-byte unchecked-char unchecked-dec
    unchecked-dec-int unchecked-divide-int unchecked-double unchecked-float
    unchecked-inc unchecked-inc-int unchecked-int unchecked-long
    unchecked-multiply unchecked-multiply-int unchecked-negate
    unchecked-negate-int unchecked-remainder-int unchecked-short
    unchecked-subtract unchecked-subtract-int underive unreduced
    unsigned-bit-shift-right update update-in update-proxy uri? use uuid? val
    vals var var-get var-set var? vary-meta vec vector vector-of vector?
    volatile! volatile? vreset! vswap!  while with-bindings with-bindings*
    with-in-str with-local-vars with-meta with-open with-out-str
    with-precision with-redefs with-redefs-fn xml-seq zero? zipmap"

    core_vars="
    *1 *2 *3 *agent* *clojure-version* *command-line-args* *compile-files*
    *compile-path* *compiler-options* *data-readers* *default-data-reader-fn*
    *e *err* *file* *flush-on-newline* *in* *ns* *out* *print-dup*
    *print-length* *print-level* *print-meta* *print-namespace-maps*
    *print-readably* *read-eval* *unchecked-math* *warn-on-reflection*"

    join() { sep=$2; set -- $1; IFS="$sep"; echo "$*"; }
    keywords() {
        words="$1"
        type="$2"
        words="$(echo "$words" |sed -e 's/[+?*\.]/\\&/g')"
        printf 'add-highlighter shared/clojure/code/ regex (?<!%s)%s(%s)(?!%s) 0:%s\n' \
            "${symbol_char}" \
            "${in_core}" \
            "$(join "${words}" '|')" \
            "${symbol_char}" \
            "${type}"
    }

    static_words="$keywords $core_fns $core_vars"
    static_words="$static_words $(for word in $static_words; do printf 'clojure.core/%s ' "$word"; done)"
    static_words="$(join "$static_words" ' ')"

    printf %s "
        add-highlighter shared/clojure/code/ regex ::?(${symbol_char}+/)?${symbol_char}+ 0:value
        $(keywords "${keywords}" keyword)
        $(keywords "${core_fns}" function)
        $(keywords "${core_vars}" variable)
        hook global WinSetOption filetype=clojure %{
            set-option window static_words $static_words
        }
    "
}

# Commands
# ‾‾‾‾‾‾‾‾

define-command -hidden clojure-filter-around-selections lisp-filter-around-selections
define-command -hidden clojure-indent-on-new-line       lisp-indent-on-new-line

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾
hook -group clojure-highlight global WinSetOption filetype=clojure %{ add-highlighter window/clojure ref clojure }

hook global WinSetOption filetype=clojure %[
    hook window ModeChange insert:.* -group clojure-hooks  clojure-filter-around-selections
    hook window InsertChar \n -group clojure-indent clojure-indent-on-new-line
]

hook -group clojure-highlight global WinSetOption filetype=(?!clojure).* %{ remove-highlighter window/clojure }

hook global WinSetOption filetype=(?!clojure).* %{
    remove-hooks window clojure-.+
}
