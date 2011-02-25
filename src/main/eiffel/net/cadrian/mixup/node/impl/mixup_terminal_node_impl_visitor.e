deferred class MIXUP_TERMINAL_NODE_IMPL_VISITOR

inherit
   VISITOR

feature {MIXUP_TERMINAL_NODE_IMPL}
   visit_mixup_terminal_node_impl (node: MIXUP_TERMINAL_NODE_IMPL) is
      require
         node /= Void
      deferred
      end

end -- class MIXUP_TERMINAL_NODE_IMPL_VISITOR
