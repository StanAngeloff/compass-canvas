module Compass::Canvas
  # This module contains all actions a backend must implement.
  module Actions
    ANTIALIAS    = :antialias
    ARC          = :arc
    ARC_REVERSE  = :arc_reverse
    BRUSH        = :brush
    CLIP         = :clip
    CLOSE        = :close
    CURVE        = :curve
    DASH_PATTERN = :dash_pattern
    FILL         = :fill
    FILL_RULE    = :fill_rule
    GROUP        = :group
    LINE         = :line
    LINE_CAP     = :line_cap
    LINE_JOIN    = :line_join
    LINE_WIDTH   = :line_width
    MASK         = :mask
    MITER_LIMIT  = :miter_limit
    MOVE         = :move
    PAINT        = :paint
    POP          = :pop
    PUSH         = :push
    RESET        = :reset
    RESTORE      = :restore
    RETRIEVE     = :retrieve
    ROTATE       = :rotate
    SAVE         = :save
    SCALE        = :scale
    SLOW_BLUR    = :slow_blur
    STORE        = :store
    STROKE       = :stroke
    TOLERANCE    = :tolerance
    TRANSFORM    = :transform
    TRANSLATE    = :translate
    UNCLIP       = :unclip
  end
end
