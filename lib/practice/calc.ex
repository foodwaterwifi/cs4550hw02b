defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  defp tag(token) do
    if (token == "+" or token == "-" or token == "*" or token == "/") do
      {:op, token}
    else
      {:num, parse_float(token)}
    end
  end

  defp is_op(text) do
    (text == "+" or text == "-" or text == "*" or text == "-")
  end

  # Compares two operators. Returns 1 if the left operator has higher precedence than the right. 0 if same. -1 otherwise.
  defp compare_ops(left, right) do
    if ((left == "+" or left == "-") and (right == "+" or right == "-")) do
      0
    else if ((left == "*" or left == "/") and (right == "*" or right == "/")) do
      0
    else if ((left == "*" or left == "/") and (right == "+" or right == "-")) do
      1
    else if ((left == "+" or left == "-") and (right == "*" or right == "/")) do
      -1
    end end end end
  end

  # Shrinks the op stack so that higher-precedence ops may be appended
  defp shrink_op_stack(op_stack, result_tokens) do
    if (op_stack == [] or length(op_stack) == 1) do
      {op_stack, result_tokens}
    else
      {:op, first_op} = hd(op_stack)
      {:op, second_op} = hd(tl(op_stack))
      # If the first op is of lower precedence than the second op
      if (compare_ops(second_op, first_op) >= 0) do
        shrink_op_stack([{:op, first_op} | tl(tl(op_stack))], result_tokens ++ [{:op, second_op}])
      else
        {op_stack, result_tokens}
      end
    end
  end

  defp to_postfix(tag_tokens, op_stack, result_tokens) do
    if (tag_tokens == []) do
      if (op_stack == []) do
        result_tokens
      else
        (result_tokens ++ op_stack)
      end
    else
      {type, val} = hd(tag_tokens)
      if (type == :op) do
        {new_op_stack, new_result_tokens} = shrink_op_stack([{type, val} | op_stack], result_tokens)
        to_postfix(tl(tag_tokens), new_op_stack, new_result_tokens)
      else
        to_postfix(tl(tag_tokens), op_stack, result_tokens ++ [{type, val}])
      end
    end
  end

  defp to_postfix(tag_tokens) do
    to_postfix(tag_tokens, [], [])
  end

  defp evaluate_postfix(tag_tokens, num_stack) do
    if (tag_tokens == []) do
      if (length(num_stack) == 1) do
        hd(num_stack)
      else
        :error
      end
    else
      {type, val} = hd(tag_tokens)
      if (type == :op) do
        if (length(num_stack) < 2) do
          :error
        else
          num2 = hd(num_stack)
          num1 = hd(tl(num_stack))
          case val do
            "+" -> evaluate_postfix(tl(tag_tokens), [num1 + num2 | tl(tl(num_stack))])
            "-" -> evaluate_postfix(tl(tag_tokens), [num1 - num2 | tl(tl(num_stack))])
            "*" -> evaluate_postfix(tl(tag_tokens), [num1 * num2 | tl(tl(num_stack))])
            "/" ->
              unless (num2 == 0) do
                evaluate_postfix(tl(tag_tokens), [num1 / num2 | tl(tl(num_stack))])
              else
                :error
              end
            _ -> :error
          end
        end
      else
        evaluate_postfix(tl(tag_tokens), [val | num_stack])
      end
    end
  end

  defp evaluate_postfix(tag_tokens) do
    evaluate_postfix(tag_tokens, [])
  end

  def calc(expr) do
    tokens = String.split(expr, ~r/\s+/)
    tag_tokens = Enum.map(tokens, &tag/1)
    postfix_tokens = to_postfix(tag_tokens);
    #{}"{#{inspect postfix_tokens}}"
    evaluate_postfix(postfix_tokens)
  end
end
