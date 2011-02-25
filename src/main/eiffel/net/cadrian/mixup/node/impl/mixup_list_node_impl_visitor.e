deferred class MIXUP_LIST_NODE_IMPL_VISITOR

inherit
   VISITOR

feature {MIXUP_LIST_NODE_IMPL}
   visit_mixup_list_node_impl (node: MIXUP_LIST_NODE_IMPL) is
      require
         node /= Void
      deferred
      end

end -- class MIXUP_LIST_NODE_IMPL_VISITOR
