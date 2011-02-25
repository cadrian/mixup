deferred class MIXUP_NON_TERMINAL_NODE_IMPL_VISITOR

inherit
   VISITOR

feature {MIXUP_NON_TERMINAL_NODE_IMPL}
   visit_mixup_non_terminal_node_impl (node: MIXUP_NON_TERMINAL_NODE_IMPL) is
      require
         node /= Void
      deferred
      end

end -- class MIXUP_NON_TERMINAL_NODE_IMPL_VISITOR
